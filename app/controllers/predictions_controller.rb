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
        rain: {value: !@interpolated_prediction.rainValue.nil? ? @interpolated_prediction.rainValue.round(2) : nil,
          probability: !@interpolated_prediction.rainProb.nil? ? @interpolated_prediction.rainProb.round(2) : nil},
        temp: {value: !@interpolated_prediction.tempValue.nil? ? @interpolated_prediction.tempValue.round(2) : nil,
          prob: !@interpolated_prediction.tempProb.nil? ? @interpolated_prediction.tempProb.round(2) : nil},
        windSpd: {value: !@interpolated_prediction.windSpeedValue.nil? ? @interpolated_prediction.windSpeedValue.round(2) : nil,
          prob: !@interpolated_prediction.windSpeedProb.nil? ? @interpolated_prediction.windSpeedProb.round(2) : nil},
        windDir: {value: !@interpolated_prediction.windDirValue.nil? ? @interpolated_prediction.windDirValue.round(2) : nil,
          prob: !@interpolated_prediction.windDirProb.nil? ? @interpolated_prediction.windDirProb.round(2) : nil}
      }
    end
    respond_to do |format|
      format.html { render html: get_prediction }
      format.json { render json: JSON.pretty_generate(@out.as_json) }
    end
  end
end
