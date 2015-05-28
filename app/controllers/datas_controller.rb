require 'json'
require 'date'

class DatasController < ApplicationController
  def get_data_by_location_id
    @date = params[:date]
    @selected_date = Date.parse(@date)
    if params[:location_ids].to_i == 0
      @station = params[:location_ids]
      @location_called = Location.find_by station: @station
    else
      get_data_by_postcode
    end


    @all_measure = @location_called.data.all
    @selected_measure = @location_called.data.where(:created_at =>
                    @selected_date.beginning_of_day..@selected_date.end_of_day)


    @current_condition = @selected_measure[0]
    @out = {date: @date,
            current_temp:@current_condition.temp,
            current_cond:@current_condition.condition,
            measurements:[]}
    @selected_measure.each do |data|
      @out[:measurements] << {
          time: data.created_at.strftime("%I:%M%P"),
          temp: data.temp,
          precip: data.precipIntense,
          wind_direction: data.windDirection,
          wind_speed: data.windSpeed
      }
    end
    respond_to do |format|
        format.html
        format.json { render json: JSON.pretty_generate(@out.as_json) }
    end

  end

  def get_data_by_postcode
    @postcode = Postcode.find_by_postcode(params[:location_ids].to_i)
    @locations = @postcode.locations

    @out = {date: Date.today,
      locations: []}
    @locations.each do |loc|
      @out[:locations] << {
        id: loc.station,
        lat: loc.lat,
        lon: loc.lon,
        last_update: loc.updated_at.strftime("%I:%M%P %F")
        #"13:12pm	21-03-2015"
      }
    end
    #
    # logger.debug "==========================================================="
    # logger.debug "HEEEEEEEEEEEEEEERRRRRRRRRRRRRRREEEEEEEEEEEEE"
    # logger.debug "==========================================================="

    respond_to do |format|
      format.html and return
      format.json { render(json: JSON.pretty_generate(@out.as_json)); return}
    end
  end


end
