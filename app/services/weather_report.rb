require "httparty"

class WeatherReport
  attr_accessor :options, :response

  SERVICE_URL = "http://api.openweathermap.org/data/2.5/weather?".freeze
  ICON_URL    = "http://openweathermap.org/img/w".freeze
  UNITS = {
    fahrenheit: "imperial",
    celsius:    "metric",
    kelvin:     "",
  }.freeze

  def initialize(options = {})
    @options = options
  end

  def fetch
    @response = build_response(HTTParty.get(SERVICE_URL, query: build_params))
  end

  private

  def build_params
    request_params = {
      appid: Rails.application.secrets.weather_api,
      units: UNITS[:celsius],
    }

    if options[:city].present?
      request_params.merge(q: options[:city])
    elsif options[:lat].present? && options[:lon].present?
      request_params.merge(lat: options[:lat], lon: options[:lon])
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

  def build_icon_link(icon)
    "#{ICON_URL}/#{icon}.png"
  end

  def build_response(api_response)
    OpenStruct.new(
      city: api_response["name"],
      country: api_response["sys"]["country"],
      lat: api_response["coord"]["lat"],
      lon: api_response["coord"]["lon"],
      weather: {
        main: api_response["weather"][0]["main"],
        description: api_response["weather"][0]["description"],
        icon: build_icon_link(api_response["weather"][0]["icon"]),
        temp: api_response["main"]["temp"],
        min: api_response["main"]["temp_min"],
        max: api_response["main"]["temp_max"],
        humidity: api_response["main"]["humidity"],
        pressure: api_response["main"]["pressure"]
      },
      success?: true
    )
  end
end

