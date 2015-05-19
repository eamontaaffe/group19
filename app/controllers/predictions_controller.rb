require 'time'

class PredictionsController < ApplicationController
  def get_prediction_by_postcode
    post_code = params[:post_code]
    period = params[:period].to_i
    @out = {post_code: post_code, predictions: {}}
    startTime = Time.now
    (0..period).step(10).each do |i|
      @out[:predictions][i] = {
        time: (startTime + 60*i).strftime("%I:%M%P %F"),
        rain: nil,
        temp: nil,
        remaining_measurements: nil
      }
    end
    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate(@out.as_json) }
    end
  end
end
