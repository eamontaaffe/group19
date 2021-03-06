include Math

class Location < ActiveRecord::Base

  belongs_to :postcode
  has_many :data
  has_many :predictions

  include NewReading
  include Regressor

  def self.find_neighbours(loc1, rad)
    # @loc1 = find(locID);
    # loc1 = [@loc1.lat,@loc1.lon]
    neighbours = Location.all.select do |loc2|
      distance_to_location(loc1,[loc2.lat,loc2.lon]) < rad
    end
    return neighbours
  end

  def distance_to(loc)
    self.class.distance_to_location(loc,[self.lat,self.lon])
  end

  def self.closest_to(latlon)
    all.sort_by{|loc| loc.distance_to(latlon)}.first
  end

  def self.closest_array(latlon,length)
    all.sort_by{|loc| loc.distance_to(latlon)}.slice(0,length)
  end

  private
  def self.distance_to_location(loc1,loc2)
    ## From http://stackoverflow.com/questions/12966638/how-to-calculate-the-
    ## distance-between-two-gps-coordinates-without-using-google-m
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad)* Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end
end
