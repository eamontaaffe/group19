require 'nokogiri'
require 'json'
require 'open-uri'
# require 'pry'
include Math

module Interpolator
  def interpolate(loc,time)
    @@ATTRIBUTES = [:rainValue, :rainProb, :tempValue,
                    :tempProb, :windSpeedValue, :windSpeedProb,
                    :windDirValue, :windDirProb] #there are more to be added

    @pred = Prediction.new() # Doesn't add it to database unless you call :save.

    @@ATTRIBUTES.each do |attribute|
      @pred.update_attribute(attribute,interpolate_attribute(loc,time,attribute))
    end
    logger.debug @pred
    return @pred
  end

  def interpolate_attribute(loc,time,attribute)
    # Hash stores interpolation method to be used depending on
    # the attribute. Default is :nearest neighbour because it
    # cant go wrong
    @@METHOD =  {};#{:rainSince9am => :inverse_distance_weighting,
                # :temp => :inverse_distance_weighting,
                # :dewPoint => :inverse_distance_weighting,
                # :wetBult => :inverse_distance_weighting,
                # :humidity => :inverse_distance_weighting,
                # :pressure => :inverse_distance_weighting,
                # :precipIntense => :inverse_distance_weighting,
                # :precipProb => :inverse_distance_weighting,
                # :cloudCover => :inverse_distance_weighting}
    @@METHOD.default = (:nearest_neighbour)

    # Call the method for the required attribute
    send(@@METHOD[attribute],loc,time,attribute)
  end

  # This method just returns the reading from the closest weather station
  def nearest_neighbour(loc,time,attribute)
    # Needs to be updated once format is known
    value = nil
    @close_locations = Location.closest_array(loc,10)
    @close_locations.reverse.each do |loc|
      pred = loc.predictions.find_by(minute: time)
      if !pred.nil?
        value = pred.send(attribute)
      end
    end
    value
  end

  # This is a local interpolation approach which uses a subset of locations
  # within a certain radius of the desired location along with a weighting
  # approach that uses the distance from the location to weight the importance
  # of the reading
  # See: http://en.wikipedia.org/wiki/Inverse_distance_weighting
  def inverse_distance_weighting(loc,time,attribute)
    @@MAX_DIST = 1000000
    @@P = 2 # Degree of weighting factor
    # Find neighbours with
    neighbours = Location.find_neighbours(loc,@@MAX_DIST)
    u_num = 0
    u_den = 0

    neighbours.each do |neighbour|
      weight = 1/(neighbour.distance_to(loc)**@@P)
      u_num += weight*neigh.prediction(time: time).send(attribute) ## Something like this
      u_den += weight
      logger.debug weight
    end
    value = u_num/u_den
    # binding.pry
    return value
  end
end
