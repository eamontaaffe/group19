require 'nokogiri'
require 'json'
require 'open-uri'
require 'pry'
include Math

module Interpolator
  # This is a local interpolation approach which uses a subset of locations
  # within a certain radius of the desired location along with a weighting
  # approach that uses the distance from the location to weight the importance
  # of the reading
  # See: http://en.wikipedia.org/wiki/Inverse_distance_weighting
  def inverse_distance_weighting(loc,time,attribute)
    @@MAX_DIST = 1000000
    @@P = 2 # Degree of weighting factor
    # Find neighbours with
    neighbours = Location.find_neighbours(locID,@@MAX_DIST)
    u_num = 0
    u_den = 0

    neighbours.each do |neighbour|
      weight = 1/(neighbour.distance_to(loc)**@@P)
      u_num += weight*neigh.prediction(time: time).send(attribute) ## Something like this
      u_den += weight
    end
    binding.pry
    return neighbours
  end
end
