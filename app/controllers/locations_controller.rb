require 'json'
require 'date'

class LocationsController < ApplicationController
  def get_locations
    @locations = Location.all

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
    respond_to do |format|
      format.html 
      format.json { render json: JSON.pretty_generate(@out.as_json) }
    end
  end
end
