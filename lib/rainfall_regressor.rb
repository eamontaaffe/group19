# require plug in the nomalized time, observation time, and the past rain fall since 9.00 of the day
  def get_rainFall_predictions(past_times,past_rainfall_values,obsv_time)
    rainfall_expectation = []
    for i in 1..(past_rainfall_values.length-1)  #get rain fall expectation value substraction of the two neighbor value
      rainfall_expectation << past_rainfall_values[i]-past_rainfall_values[i-1]
    end

    for i in 1..(obsv_time.length-1)   #clear the rainfall expectation value if different day
      obsv_time_date1 = obsv_time[i]
      obsv_time_date2 = obsv_time[i-1]
      if obsv_time_date1[8..9].to_f-obsv_time_date2[8..9].to_f>0
        rainfall_expectation[i-1] =past_rainfall_values[i];
      end
    end
    past_times.delete_at(past_times.length-1)
    betas = poly_regression(past_times,rainfall_expectation)
    future_times = []
    future_probs = []
    r_squared = calc_r_squared(calc_fitted_data(betas,past_times), rainfall_expectation)
    (0..190).each do |min_from_now|
      future_times << min_from_now
      future_probs << r_squared
    end

    ##this part convert the expectation value back to since 9 am value
    future_rainfall_expection = calc_fitted_data(betas,future_times[1..189])
    current_rainfall =past_rainfall_values.last(1)
   furure_rainfall_temp = current_rainfall
    future_rainfall_expection.each do |rainfall|
      furure_rainfall_temp<<rainfall
    end
    furure_rainfall = []
    sum = current_rainfall[0]
    for i in 1..(furure_rainfall_temp.length)
      for j in 0..i-2
        sum = sum +furure_rainfall_temp[j]
      end
      furure_rainfall<<sum
      sum = 0
    end

    return  future_times, furure_rainfall, future_probs

  end