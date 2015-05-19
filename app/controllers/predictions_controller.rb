require 'time'

class PredictionsController < ApplicationController
  def get_prediction_by_postcode
    postcode = params[:post_code]
    period = params[:period]
    @out = {location_id: postcode, predictions: {}}
    startTime = DateTime.now
    endTime = startTime + period.minutes
    (startTime..endTime).step(15*60).each do |i|
      @out[:predictions][i] = {
        time: Date
      }
    end
    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate(@out.as_json) }
    end
  end
end
