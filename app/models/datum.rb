class Datum < ActiveRecord::Base
  belongs_to :location

  include Scraper
end
