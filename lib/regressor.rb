=begin
# project 1 - polynomial method
def poly_regress
  # iterate through n = 2 to n = 10
  temp_betas = Array.new
  temp_R2s = Array.new
  (2..10).each do |order|
    x_data = @time.map { |x| (0..order).map { |pow| (x**pow).to_f } }
    temp_b = LS_fit.call(x_data,@data)
    temp_betas.push(temp_b)
    temp_R2s.push(r_squared(fitted_y(temp_b,'polynomial')))
  end
  # return equation coefficients with highest R^2 value
  return temp_betas[temp_R2s.index(temp_R2s.max)]
end
=end

require 'Matrix'
# require 'statsample'

# time is in UNIX epoch, units = seconds

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

# times are in UNIX epoch, units = seconds
def get_temp_predictions(current_time,past_times,past_temp_values)
  betas = poly_regression(past_times,past_temp_values)
  future_times = []
  future_probs = []
  r_squared = calc_r_squared(calc_fitted_data(betas,past_times),past_temp_values)
  (0..180).each do |min_from_now|
    future_time = current_time+min_from_now*60
    future_times << future_time
    future_probs << r_squared
  end
  future_temps = calc_fitted_data(betas,future_times)
  return future_times, future_temps, future_probs
end

=begin
# test code
# input_1 = lambda {|val| 2*(val**5) - 3*(val**3) + 19.8*val - 12.92 }
input_1 = lambda { |val| 50+rand(50) }
test_x = []
test_y = []
(1..100).each do |x|
  test_x << Time.now.to_i + 60*x
  test_y << input_1.call(x)
end
puts test_x.map{ |x| Math.log(x,10)}
puts test_y

b = poly_regression(test_x,test_y)
puts b
est_y = calc_fitted_data(b,test_x)
puts est_y
puts calc_r_squared(est_y,test_y)

puts get_temp_predictions(Time.now.to_i,test_x,test_y)
=end