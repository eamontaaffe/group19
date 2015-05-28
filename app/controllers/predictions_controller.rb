require 'time'
include Geocode
include Interpolator

class PredictionsController < ApplicationController
  def get_prediction_by_postcode
    post_code = params[:post_code]
    latlon = postcode_to_lat_lon(post_code)

    @lat = latlon[:lat].to_f
    @lon = latlon[:lon].to_f
    @out = {post_code: post_code}

    get_prediction
  end

  def get_prediction_by_lat_lon
    @lat = params[:lat].to_f
    @lon = params[:long].to_f
    @out = {lattitude: @lat, longitude: @lon}

    get_prediction
  end

  def get_prediction
    # @lat = params[:lat]
    # @lon = params[:lon]
    # @out = params[:out]
    #
    @out[:prediction] = {}
    period = params[:period].to_i

    startTime = Time.now
    (0..period).step(10).each do |i|
      @interpolated_prediction = interpolate([@lat,@lon],i)
      @out[:prediction][i] = {
        time: (startTime + 60*i).strftime("%I:%M%P %m-%d-%Y"),
        rain: {value: @interpolated_prediction.rainValue.round(2),
          probability: @interpolated_prediction.rainProb.round(2)},
        temp: {value: @interpolated_prediction.tempValue.round(2),
          prob: @interpolated_prediction.tempProb.round(2)},
        windSpd: {value: @interpolated_prediction.windSpeedValue.round(2),
          prob: @interpolated_prediction.windSpeedProb.round(2)},
        windDir: {value: @interpolated_prediction.windDirValue,
          prob: @interpolated_prediction.windDirProb}
      }
    end
    respond_to do |format|
      format.html {render get_prediction}
      format.json { render json: JSON.pretty_generate(@out.as_json) }
    end
  end
end
