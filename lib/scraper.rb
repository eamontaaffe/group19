require 'nokogiri'
require 'open-uri'
require 'json'

# web scraping methods and importers used to get station level readings
module Scraper

# Define the BoM URL we are opening
  URL = 'http://www.bom.gov.au/vic/observations/vicall.shtml'

# ForecastIO unique API keys
  API_KEY_1 = '1e33ffaa15047094eef5cf43468bc8d2'
  API_KEY_2 = '47664ca29b361759de7e5f2c33791020'
  API_KEY_3 = '1e33ffaa15047094eef5cf43468bc8d2'
# ForecastIO base URL
  BASE_URL = 'https://api.forecast.io/forecast'

  # convert BOM timestamp to ISO 8601 time
  # dd/hh:mm[am/pm] to yyyy-mm-ddThh:mm:ss
  def toISOtime(bom_time)
    time = Time.new
    iso_time = String.new
    iso_time.concat("%d-%02d-%02dT" % [time.year, time.month, bom_time[0..1].to_i])
    if bom_time[8..9] == 'pm'
      iso_time.concat("#{bom_time[3..4].to_i + 12}")
    else
      iso_time.concat("#{bom_time[3..4]}")
    end
    iso_time.concat(":#{bom_time[6..7]}:00")
  end

  # convert direction to ForecastIO bearing
  # BOM: 16-compass rose, FOI: CW bearing from N that wind is blowing FROM
  def toBearing(dir)
    dir_table = %w(N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW CALM)
    bearing_table = [0,22.5,45,67.5,90,112.5,135,157.5,180,202.5,225,247.5,270,292.5,315,337.5,360,nil]
    return bearing_table[dir_table.find_index(dir)]
  end

  # calculate expected rainfall for given precipIntense and precipProb
  def calcRainExpected
    if (self.precipIntensity != nil) && (self.precipProb != nil)
      return self.precipIntensity*self.precipProb
    else
      return nil
    end
  end

  # average value function
  def avgValue(val1, val2)
    if val1 == nil
      return val2
    end
    return ((val1+val2)*0.5)
  end

  # import data from BoM
  def import_BOMdata
    # Get station name for given location
    obs_station = Location.find(self.location_id).station
    # Open the HTML link with Nokogiri
    doc = Nokogiri::HTML(open(URL))
    # Get time and convert to ISO standard
    bom_time = doc.css("td[headers*='datetime'][headers*=#{obs_station}]").text
    self.obsTime = self.toISOtime(bom_time)
    # Get other weather attributes
    self.temp = doc.css("td[headers*='tmp'][headers*=#{obs_station}]").text
    self.dewPoint = doc.css("td[headers*='dewpoint'][headers*=#{obs_station}]").text
    self.humidity = doc.css("td[headers*='relhum'][headers*=#{obs_station}]").text
    self.wetBulb = doc.css("td[headers*='delta-t'][headers*=#{obs_station}]").text
    self.pressure = doc.css("td[headers*='pressure'][headers*=#{obs_station}]").text
    # Convert dir to bearing
    self.windDirection= doc.css("td[headers*='-wind-dir'][headers*=#{obs_station}]").text
    self.windSpeed= doc.css("td[headers*='wind-spd-kmh'][headers*=#{obs_station}]").text
    self.rainSince9am = doc.css("td[headers*='rainsince9am'][headers*=#{obs_station}]").text
    # Set source identifier
    self.source = 'bom'
  end

  # import data from ForecastIO
  def import_FIOdata
    # Cycle API keys depending in time of day - more available calls
    current = Time.now
    if (current.hour >= 00 && current.hour < 8)
      key = API_KEY_1
    elsif (current.hour >= 8 && current.hour < 16)
      key = API_KEY_2
    else
      key = API_KEY_3
    end
    # Get longitude and latitude data for API call
    lat_long = "#{Location.find(self.location_id).lat},#{Location.find(self.location_id).lon}"
    # Read in data as JSON
    forecast = JSON.parse(open("#{BASE_URL}/#{key}/#{lat_long},#{current.to_i}?units=ca").read)
    # Aggregate new data with existing data in StationReading object
    self.temp = forecast["currently"]["temperature"]
    self.dewPoint = forecast["currently"]["dewPoint"]
    self.windBearing = forecast["currently"]["windBearing"]
    self.windSpeed = forecast["currently"]["windSpeed"]
    self.precipIntense = forecast["currently"]["precipIntensity"]
    self.precipProb = forecast["currently"]["precipProbability"]
    self.condition = forecast["currently"]["summary"]
    self.humidity = forecast["currently"]["humidity"]
    self.pressure = forecast["currently"]["pressure"]
    self.cloudCover = forecast["currently"]["cloudCover"]
    # Set source identifier
    self.source = 'fio'
  end

end
