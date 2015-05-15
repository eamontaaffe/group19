require 'nokogiri'
require 'json'
require 'open-uri'
require 'debugger'

module Interpolator
  @@GEOCODE_API_KEY = "AIzaSyAc_WiZgYEUu9dGCiNcR_0v652lY2uugJ0"
  @@GEOCODEURL = "https://maps.googleapis.com/maps/api/geocode/"

  def postcode_to_lat_lon(postcode)
    query_to_lat_lon(postcode)
  end
  def station_to_lat_lon(station)
    query_to_lat_lon(station)
  end
  def query_to_lat_lon(query)
    address = "#{query.to_s.gsub(/\s/,'+')}+Victoria+Australia"
    geocode = JSON.parse(open(
      "#{@@GEOCODEURL}json?address=#{address}&key=#{@@GEOCODE_API_KEY}").read)
    return geocode["results"].first["geometry"]["location"]
  end
  def station_to_postcode(station)
    address = "#{station.to_s.gsub(/\s/,'+')}+Victoria+Australia"
    geocode = JSON.parse(open(
      "#{@@GEOCODEURL}json?address=#{address}&key=#{@@GEOCODE_API_KEY}").read)
    address_components = geocode["results"].first["address_components"]
    postal_codes = address_components.select {|c| c["types"] == ["postal_code"]}
    postal_codes.first["long_name"].to_i
  end
end
