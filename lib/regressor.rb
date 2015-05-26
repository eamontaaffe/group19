require 'Matrix'

module Regressor
# require 'statsample'

# == CRUDE PREDICTOR BASED ON PROJECT 1 METHODS ==

# least squares fit bloc
  LS_fit = lambda { |x_data,y_data|
    # least squares regression - matrix method
    m_x = Matrix[*x_data]
    m_y = Matrix.column_vector(y_data)
    betas = ((m_x.t*m_x).inv * m_x.t * m_y).transpose.to_a[0]
    # return coefficients to 2 d.p.
    return betas.map { |b| b.round(2) }
  }

  def poly_regression(x_var,y_var)
    # 10th order polynomial regression
    order = 10
    x_data = x_var.map { |x| (0..order).map { |pow| (x**pow).to_f } }
    return LS_fit.call(x_data,y_var)
  end

  def calc_fitted_data(betas, x_var)
    fitted_data = []
    x_var.each do |t|
      temp_var = 0
      for deg in (betas.length-1).downto(0)
        temp_var += betas[deg]*(t**deg)
      end
      # append final value as fitted y value
      fitted_data.push(temp_var)
    end
    return fitted_data
  end

  def calc_r_squared(fitted_data, y_var)
    # sum of squares total
    ss_total = y_var.map { |y| y-((y_var.reduce :+)/(y_var.length)) }
    ss_total = ss_total.map { |err| err**2 }
    ss_total = ss_total.reduce :+
    # sum of squares residual
    ss_residual = y_var.zip(fitted_data).map { |x,y| x-y }
    ss_residual = ss_residual.map { |err| err**2 }
    ss_residual = ss_residual.reduce :+
    # R^2
    return (1 - (ss_residual/ss_total))
  end

# == WEATHER APP SPECIFIC METHODS ==

  HORIZON = 190

# times are in MINUTES, now = 0, past = neg
  def get_temp_predictions(past_times,past_temp_values)
    betas = poly_regression(past_times,past_temp_values)
    future_times = []
    future_probs = []
    r_squared = calc_r_squared(calc_fitted_data(betas,past_times),past_temp_values)
    # add buffer for possible user call within 10 min of last prediction generation
    (0..HORIZON).each do |min_from_now|
      future_times << min_from_now
      future_probs << r_squared
    end
    future_temps = calc_fitted_data(betas,future_times)
    return future_times, future_temps, future_probs
  end

# == WRITING NEW PREDICTIONS ==

# convert obsTime string to Time object
  def obs_to_datetime(obsTime)
    return Time.new(obsTime[0..3],obsTime[5..6],obsTime[8..9],obsTime[11..12],obsTime[14..15],obsTime[17..18])
  end

  def new_location_predictions
    # delete all past predictions for location
    self.predictions.delete_all
    # store current time, must be constant throughout method call
    currentTime = Time.now
    # initialise arrays
    past_times = []
    past_temps = []
    past_windSpeeds = []
    past_windDirections = []
    past_rains = []
    # self is a Location object with Data and Predictions
    # limit data to last 100 points to avoid silly regressions
    self.data.where(source:'bom').last(100).each do |dp|
      # current time is 0 min, past times are neg min from current
      past_times << -((currentTime-obs_to_datetime(dp.obsTime))/60).round
      past_temps << dp.temp
      past_windDirections << dp.windDirection
      past_windSpeeds << dp.windSpeed
    end
    # regress all variables of interest
    temp_predictions = get_temp_predictions(past_times,past_temps)
    # write new predictions
    (0..HORIZON).each do |min_from_now|
      new_prediction = Prediction.new(location: self)
      new_prediction.tempValue = temp_predictions[1][min_from_now]
      new_prediction.tempProb = temp_predictions[2][min_from_now]
      new_prediction.save
    end
  end

end