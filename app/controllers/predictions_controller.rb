require 'time'
include Geocode

class PredictionsController < ApplicationController
  def get_prediction_by_postcode
    post_code = params[:post_code]
    latlon = postcode_to_lat_lon(post_code)

    @lat = latlon[:lat]
    @lon = latlon[:lon]
    @out = {post_code: post_code}

    redirect_to get_prediction
  end

  def get_prediction_by_lat_lon
    @lat = params[:lat]
    @lon = params[:lon]
    @out = {lattitude: @lat, longitude: @lon}

    redirect_to get_prediction
  end

  def get_prediction
    @out[:prediction] = {}
    period = params[:period].to_i

    startTime = Time.now
    # (0..period).step(10).each do |i|
    #   @out[:predictions][i] = {
    #     time: (startTime + 60*i).strftime("%I:%M%P %F"),
    #     rain: nil,
    #     temp: nil,
    #     remaining_measurements: nil
    #   }
    # end
    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate(@out.as_json) }
    end
  end
end
