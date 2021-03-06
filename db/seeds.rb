require "#{Rails.root}/app/helpers/geocode"
include Geocode

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Pre-load Victorian BoM observation stations
Location.create(station: 'charlton', lat: -36.28, lon: 143.33)
Location.create(station: 'hopetoun-airport', lat: -35.72, lon: 142.36)
Location.create(station: 'mildura', lat: -34.24, lon: 142.09)
Location.create(station: 'ouyen', lat: -35.07, lon: 142.31)
Location.create(station: 'swan-hill', lat: -35.38, lon: 143.54)
Location.create(station: 'walpeup-rs', lat: -35.12, lon: 142.00)

Location.create(station: 'edenhope', lat: -37.02, lon: 141.27)
Location.create(station: 'horsham', lat: -36.67, lon: 142.17)
Location.create(station: 'kanagulk', lat: -37.12, lon: 141.80)
Location.create(station: 'nhill-aerodrome', lat: -36.31, lon: 141.65)
Location.create(station: 'stawell', lat: -37.07, lon: 142.74)

Location.create(station: 'ben-nevis', lat: -37.23, lon: 143.20)
Location.create(station: 'cape-nelson', lat: -38.43, lon: 141.54)
Location.create(station: 'cape-otway', lat: -38.86, lon: 143.51)
Location.create(station: 'casterton', lat: -37.58, lon: 141.33)
Location.create(station: 'hamilton', lat: -37.65, lon: 142.06)
Location.create(station: 'mortlake', lat: -38.07, lon: 142.77)
Location.create(station: 'mount-gellibrand', lat: -38.23, lon: 143.79)
Location.create(station: 'mount-william', lat: -37.30, lon: 142.60)
Location.create(station: 'port-fairy', lat: -38.39, lon: 142.23)
Location.create(station: 'portland-airport', lat: -38.31, lon: 141.47)
Location.create(station: 'warrnambool', lat: -38.29, lon: 142.45)
Location.create(station: 'westmere', lat: -37.71, lon: 142.94)

Location.create(station: 'aireys-inlet', lat: -38.46, lon: 144.09)
Location.create(station: 'avalon', lat: -38.03, lon: 144.48)
Location.create(station: 'ballarat', lat: -37.51, lon: 143.79)
Location.create(station: 'cerberus', lat: -38.36, lon: 145.18)
Location.create(station: 'coldstream', lat: -37.72, lon: 145.41)
Location.create(station: 'essendon-airport', lat: -37.73, lon: 144.91)
Location.create(station: 'ferny-creek', lat: -37.87, lon: 145.35)
Location.create(station: 'frankston', lat: -38.15, lon: 145.12)
Location.create(station: 'geelong-racecourse', lat: -38.17, lon: 144.38)
Location.create(station: 'laverton', lat: -37.86, lon: 144.76)
Location.create(station: 'melbourne-airport', lat: -37.67, lon: 144.83)
Location.create(station: 'melbourne-olympic-park', lat: -37.83, lon: 144.98)
Location.create(station: 'moorabbin-airport', lat: -37.98, lon: 145.10)
Location.create(station: 'pound-creek', lat: -38.63, lon: 145.81)
Location.create(station: 'rhyll', lat: -38.46, lon: 145.31)
Location.create(station: 'scoresby', lat: -37.87, lon: 145.26)
Location.create(station: 'sheoaks', lat: -37.91, lon: 144.13)
Location.create(station: 'viewbank', lat: -37.74, lon: 145.10)

Location.create(station: 'bendigo', lat: -36.74, lon: 144.33)
Location.create(station: 'kyabram', lat: -36.34, lon: 145.06)
Location.create(station: 'mangalore', lat: -36.89, lon: 145.19)
Location.create(station: 'redesdale', lat: -37.02, lon: 144.52)
Location.create(station: 'shepparton', lat: -36.43, lon: 145.39)
Location.create(station: 'tatura', lat: -36.44, lon: 145.27)
Location.create(station: 'yarrawonga', lat: -36.03, lon: 146.03)

Location.create(station: 'albury', lat: -36.07, lon: 146.95)
Location.create(station: 'falls-creek', lat: -36.87, lon: 147.28)
Location.create(station: 'hunters-hill', lat: -36.21, lon: 147.54)
Location.create(station: 'mount-buller', lat: -37.15, lon: 146.44)
Location.create(station: 'mount-hotham-airport', lat: -37.05, lon: 147.33)
Location.create(station: 'mount-hotham-aws', lat: -36.98, lon: 147.13)
Location.create(station: 'rutherglen-rs', lat: -36.10, lon: 146.51)
Location.create(station: 'wangaratta', lat: -36.42, lon: 146.31)

Location.create(station: 'eildon-fire-tower', lat: -37.21, lon: 145.84)
Location.create(station: 'kilmore-gap', lat: -37.38, lon: 144.97)

Location.create(station: 'east-sale', lat: -38.12, lon: 147.13)
Location.create(station: 'hogan-island', lat: -39.22, lon: 146.98)
Location.create(station: 'latrobe-valley', lat: -38.21, lon: 146.47)
Location.create(station: 'mount-baw-baw', lat: -37.84, lon: 146.27)
Location.create(station: 'mount-moornapa', lat: -37.75, lon: 147.14)
Location.create(station: 'warragul-nilma-north', lat: -38.13, lon: 145.99)
Location.create(station: 'wilsons-promontory', lat: -39.13, lon: 146.42)
Location.create(station: 'yanakie', lat: -38.81, lon: 146.19)
Location.create(station: 'yarram-airport', lat: -38.56, lon: 146.75)

Location.create(station: 'bairnsdale', lat: -37.88, lon: 147.57)
Location.create(station: 'combienbar', lat: -37.34, lon: 149.02)
Location.create(station: 'gabo-island', lat: -37.57, lon: 149.92)
Location.create(station: 'gelantipy', lat: -37.22, lon: 148.26)
Location.create(station: 'mallacoota', lat: -37.60, lon: 149.73)
Location.create(station: 'mount-nowa-nowa', lat: -37.69, lon: 148.09)
Location.create(station: 'omeo', lat: -37.10, lon: 147.60)
Location.create(station: 'orbost', lat: -37.69, lon: 148.47)

# (3000..3999).each do |pc|
#   Postcode.create(postcode: pc)
# end

Location.all.each do |location|
  puts "--------------------------------------------------------------"
  puts "#{location.station.upcase} : #{station_to_postcode(location.station)}"
  postcode = station_to_postcode(location.station);
  if postcode.class != String
    begin
      a = Postcode.new(postcode: postcode)
      if a.save!
        location.update_attribute(:postcode_id, a.id)
        puts "POSTCODE ADDED!"
      end
    rescue Exception
    end
  end
  puts "--------------------------------------------------------------"
end
