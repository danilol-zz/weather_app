require "httparty"

class WeatherReport
  attr_accessor :api_key, :url, :response

  SERVICE_URL = "http://api.openweathermap.org/data/2.5/weather?"

  def initialize
    @api_key = Rails.application.secrets.weather_api
    @url     = SERVICE_URL
  end

  def berlin_report
    @response = HTTParty.get(url, query: build_params)
  end

  private

  def build_params
    {
      appid: @api_key,
      lat:  52.554486,
      lon:  13.376573
    }
  end
end
