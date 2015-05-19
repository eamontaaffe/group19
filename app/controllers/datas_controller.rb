require 'json'
require 'date'

class DatasController < ApplicationController
  def get_data_by_location_id
    @date = params[:date]
    @selected_date = Date.parse(@date)
    @station = params[:location_ids]
    @location_called = Location.find_by station: @station
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
          time: data.created_at,
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


end