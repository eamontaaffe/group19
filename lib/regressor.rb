require 'matrix'
require 'statsample'
require 'bigdecimal'

module Regressor

# == BASIC PREDICTORS BASED ON PROJECT 1 ==

# least squares fit bloc - called in other regression methods
  LS_fit = lambda { |x_data,y_data|
    # least squares regression - matrix method
    m_x = Matrix[*x_data]
    m_y = Matrix.column_vector(y_data)
    betas = ((m_x.t*m_x).inv * m_x.t * m_y).transpose.to_a[0]
    # return coefficients to 2 d.p.
    return betas.map { |b| b.round(2) }
  }

# get expected output for some given x-variables and beta coefficients
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

=begin
  def calc_fitted_data_log(betas,x_var)
    fitted_data = []
    x_var.each do |x|
      fitted_data.push(betas[0]+betas[1]*Math.log(x))
    end
    return fitted_data
  end

  def calc_fitted_data_exp(betas,x_var)
    fitted_data = []
    x_var.each do |x|
      fitted_data.push(betas[0]*Math.exp(betas[1]*x))
    end
    return fitted_data
  end
=end

# get R^2 statistic - goodness of fit
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

  # multiple order polynomial regression - returns best order of betas
  def poly_regress(x_var,y_var)
    # iterate through n = 2 to n = 10
    temp_betas = Array.new
    temp_R2s = Array.new
    (2..10).each do |order|
      x_data = x_var.map { |x| (0..order).map { |pow| (x**pow).to_f } }
      temp_b = LS_fit.call(x_data,y_var)
      temp_betas.push(temp_b)
      temp_R2s.push(calc_r_squared(calc_fitted_data(temp_b,x_var),y_var))
    end
    # return equation coefficients with highest R^2 value
    return temp_betas[temp_R2s.index(temp_R2s.max)]
  end

  # simple linear regression using statsample gem
  def simple_regress(x_var,y_var)
    # cast x and y vars as appropriate vectors to statsample object
    return Statsample::Regression.simple(x_var.to_scale,y_var.to_scale)
  end

  def linear_regress(x_var,y_var)
    reg = simple_regress(x_var,y_var)
    return [reg.b, reg.a]
    # a is constant, b is coefficient
  end

=begin
  # natural logarithmic regression - reuses simple_regress
  def log_regress(x_var,y_var)
    begin
      x_data = x_var.map { |x| Math.log(x) }
    rescue Math::DomainError
      # catch out of domain error
      return :outDom
    end
    reg = simple_regress(x_data,y_var)
    # append column of ones to regress constants
    return [reg.b, reg.a]
  end

  # exponential regression - reuses simple_regress
  def exp_regress(x_var,y_var)
    begin
      y_data = y_var.map { |y| Math.log(y) }
    rescue Math::DomainError
      # catch out of domain error
      return :outDom
    end
    reg = simple_regress(x_var,y_data)
    # append column of ones to regress constants
    betas = [reg.b, reg.a]
    # take exponent of constant to correct coefficient
    betas[0] = Math.exp(betas[0])
    return betas
  end
=end

  # get best equation of fit for given data set
  def get_best_betas(x_var,y_var)
    betas = []
    rs = []
    betas.push(poly_regress(x_var,y_var))
    betas.push(linear_regress(x_var,y_var))
    # betas.push(log_regress(x_var,y_var))
    # betas.push(exp_regress(x_var,y_var))
    # type = String.new
    betas.each_index do |b|
      rs.push(calc_r_squared(calc_fitted_data(betas[b],x_var),y_var))
=begin
      if betas[b] != :outDom
        if b == 2
          rs.push(calc_r_squared(calc_fitted_data_log(betas[b],x_var),y_var))
          type = 'log'
        elsif b == 3
          rs.push(calc_r_squared(calc_fitted_data_exp(betas[b],x_var),y_var))
          type = 'exp'
        else
          rs.push(calc_r_squared(calc_fitted_data(betas[b],x_var),y_var))
          type = 'lin'
        end
      else
        # substitute error string for unobtainable R^2
        rs.push(-1000)
      end
=end
    end
=begin
    # debugging
    puts "location #{self.id}"
    puts "betas #{betas}"
    puts "r^2 #{rs}"
    # catch NaN errors
    betas.each_index do |i|
      if betas[i].nan?
        betas[i] = -1000
      end
    end
=end
    # return betas[rs.index(rs.max)], rs.max, type
    return betas[rs.index(rs.max)], rs.max
  end

# == WEATHER APP SPECIFIC METHODS ==

# add buffer for possible user call within 10 min of last prediction generation
# future times are positive 0..190 min
  # HORIZON = 190
# min intervals specified only
  TIME_INT = [10,30,60,120,180]
# sec intervals specified only
  TIME_INT_UNIX = [10*60,30*60,60*60,120*60,180*60]

# calculating forecast
  def get_generic_predictions(currentTime,past_times,past_values)
    # coefficients are in the first nested array
    reg_result = get_best_betas(past_times,past_values)
    betas = reg_result[0]
    # initialise secondary arrays
    future_times = []
    future_probs = []
    # R^2 is the middle element of the nested array
    r_squared = reg_result[1]
    (TIME_INT).each do |t_from_now|
      future_times << t_from_now.to_f
      # probability should be decreasing further into horizon
      # arbitrary decrease in R^2, statistically makes no sense, but whatever...
      future_probs << r_squared
      # future_probs << r_squared*(1-(min_from_now/HORIZON)*0.1)
    end
    # regression type is the last element of the nested array
    # type = reg_result[2]
    future_values = calc_fitted_data(betas,future_times)
=begin
    case type
      when 'log'
        future_values = calc_fitted_data_log(betas,future_times)
      when 'exp'
        future_values = calc_fitted_data_exp(betas,future_times)
      when 'lin'
        future_values = calc_fitted_data(betas,future_times)
    end
=end
    # return [[val],[prob]] nested array
    return future_values, future_probs
  end

  def get_temp_predictions(currentTime,past_times,past_temps)
    return get_generic_predictions(currentTime,past_times,past_temps)
  end

  def get_windspeed_predictions(currentTime,past_times,past_speeds)
    return get_generic_predictions(currentTime,past_times,past_speeds)
  end

# == WRITING NEW PREDICTIONS ==

# Convert obsTime string to Ruby Time object
  def obs_to_datetime(obsTime)
    return Time.new(obsTime[0..3],obsTime[5..6],obsTime[8..9],obsTime[11..12],obsTime[14..15],obsTime[17..18])
  end

=begin
# WRITING TO THE DATABASE - PRE-GENERATION METHOD
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
    # limit data to last 100 points
    self.data.where(source:'bom').last(100).each do |dp|
      # current time is 0 min, past times are neg min from current
      past_times << -((currentTime-obs_to_datetime(dp.obsTime)).to_r/60).round
      # past_times << obs_to_datetime(dp.obsTime).to_i
      past_temps << dp.temp
      past_windDirections << dp.windDirection
      past_windSpeeds << dp.windSpeed
      past_rains << dp.rainSince9am
    end
    puts "times #{past_times.size}"
    puts past_times
    puts "temps #{past_temps.size}"
    puts past_temps
    puts "dirs #{past_windDirections.size}"
    puts past_windDirections
    puts "speeds #{past_windSpeeds.size}"
    puts past_windSpeeds
    puts "rains #{past_rains.size}"
    puts past_rains
    # regress all variables of interest
    temp_predictions = get_temp_predictions(0,past_times,past_temps)
    windSpeed_predictions = get_windspeed_predictions(0,past_times,past_windSpeeds)
=begin
    # write new predictions - minute by minute (0..HOR)
    (0..HORIZON).each do |min_from_now|
      new_prediction = Prediction.new(location: self)
      new_prediction.minute = min_from_now
      new_prediction.tempValue = temp_predictions[0][min_from_now]
      new_prediction.tempProb = temp_predictions[1][min_from_now]
      new_prediction.windSpeedValue = windSpeed_predictions[0][min_from_now]
      new_prediction.windSpeedProb = windSpeed_predictions[1][min_from_now]
      new_prediction.save
    end
=end
=begin
    # write new predictions - spec intervals (TIME_INT)
    TIME_INT.each_index do |index|
      new_prediction = Prediction.new(location: self)
      new_prediction.minute = TIME_INT[index]
      new_prediction.tempValue = temp_predictions[0][index]
      new_prediction.tempProb = temp_predictions[1][index]
      new_prediction.windSpeedValue = windSpeed_predictions[0][index]
      new_prediction.windSpeedProb = windSpeed_predictions[1][index]
      new_prediction.save
    end
end
=end

# ON-CALL METHOD
  def instant_location_predictions
    # store current time, must be constant throughout method call
    currentTime = Time.now
    # initialise arrays
    past_times = []
    past_temps = []
    past_windSpeeds = []
    past_windDirections = []
    past_rains = []
    # self is a Location object with Data and Predictions
    # limit data to last 100 points
    self.data.where(source:'bom').last(100).each do |dp|
      # current time is 0 min, past times are neg min from current
      past_times << currentTime.minus_with_coercion(obs_to_datetime(dp.obsTime))/60.0
      # past_times << obs_to_datetime(dp.obsTime).to_r
      past_temps << dp.temp
      past_windDirections << dp.windDirection
      past_windSpeeds << dp.windSpeed
      past_rains << dp.rainSince9am
    end
    # regress all variables of interest
    temp_predictions = get_temp_predictions(0.0,past_times,past_temps)
    windSpeed_predictions = get_windspeed_predictions(0.0,past_times,past_windSpeeds)
    # generate hash
    forecast = []
    TIME_INT.each_index do |index|
      sub_array = []
      sub_array << TIME_INT[index]
      sub_array << [temp_predictions[0][index], temp_predictions[1][index]]
      sub_array << [windSpeed_predictions[0][index], windSpeed_predictions[1][index]]
      forecast << sub_array
    end
    return forecast
  end

end