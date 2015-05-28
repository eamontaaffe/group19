require 'nokogiri'
require 'json'
require 'open-uri'
# require 'pry'
include Math

module Geocode
  @@GEOCODE_API_KEY = "AIzaSyAc_WiZgYEUu9dGCiNcR_0v652lY2uugJ0"
  @@GEOCODEURL = "https://maps.googleapis.com/maps/api/geocode/"

  def postcode_to_lat_lon(postcode)
    geocode = query_to_json(postcode)
    top_result = geocode["results"].first
    debugger
    out = top_result["geometry"]["location"]
    id_info = top_result["address_components"].select{|c| c["types"].include? "colloquial_area"}
    id = id_info.first["short_name"]
    {lat: out["lat"], lon: out["lng"], id: id}
  end
  def station_to_lat_lon(station)
    geocode = query_to_json(station)
    out = geocode["results"].first["geometry"]["location"]
    {lat: out["lat"], lon: out["lng"]}
  end
  def query_to_json(query)
    address = "#{query.to_s.gsub(/\s/,'+')}+Victoria+Australia"
    geocode = JSON.parse(open(
      "#{@@GEOCODEURL}json?address=#{address}&key=#{@@GEOCODE_API_KEY}").read)

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
