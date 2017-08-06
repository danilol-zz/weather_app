require "httparty"

class WeatherReport
  attr_accessor :options, :response

  SERVICE_URL = "http://api.openweathermap.org/data/2.5/weather?"

  UNITS = {
    fahrenheit: "imperial",
    celsius:    "metric",
    kelvin:     "",
  }.freeze

  def initialize(options = {})
    @options = options
  end

  def fetch
    @response = HTTParty.get(SERVICE_URL, query: build_params)
  end

  private

  def build_params
    request_params = {
      appid: Rails.application.secrets.weather_api,
      units: UNITS[:celsius],
    }

    if options[:city].present?
      request_params.merge(q: options[:city])
    else
      request_params.merge(lat: rand_lat, lon: rand_lon)
    end
  end

  def rand_lat
    rand(-90.000000000...90.000000000)
  end

  def rand_lon
    rand(-180.000000000...180.000000000)
  end
end
