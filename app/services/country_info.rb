require "httparty"

class CountryInfo
  include HTTParty

  attr_accessor :country, :response

  base_uri        'https://restcountries.eu/'
  default_timeout 120
  CACHE_EXPIRATION = 5.minutes

  def initialize(options = {})
    @country = options[:country]
  end

  def fetch
    @response = request_service
  end

  private

  def request_service
    begin
      handle_timeouts do
        handle_caching do
          self.class.get("/rest/v2/name/#{country}")
        end
      end
    rescue => e
      build_error_response({ "cod" => 500, "message" => "Internal Error"})
    end
  end

  def build_success_response(api_response)
    country = api_response.first

    OpenStruct.new(
      name: country["name"],
      domain: country["topLevelDomain"],
      alpha2Code: country["alpha2Code"],
      alpha3Code: country["alpha3Code"],
      calling_codes: country["callingCodes"],
      capital: country["capital"],
      alt_spellings: country["altSpellings"],
      region: country["region"],
      subregion: country["subregion"],
      population: country["population"],
      latlng: country["latlng"],
      demonym: country["demonym"],
      area: country["area"],
      gini: country["gini"],
      timezones: country["timezones"],
      borders: country["borders"],
      native_name: country["nativeName"],
      numeric_code: country["numericCode"],
      currencies: country["currencies"],
      languages: country["languages"],
      translations: country["translations"],
      flag: country["flag"],
      regional_blocs: country["regionalBlocs"],
      other_acronyms: country["otherAcronyms"],
      success?: true
    )
  end

  def build_error_response(api_response)
    OpenStruct.new(
      code: api_response["cod"].to_i,
      message: api_response["message"],
      success?: false
    )
  end

  def handle_timeouts
    begin
      yield
    rescue Net::OpenTimeout, Net::ReadTimeout
      build_error_response({ "cod" => 408, "message" => "Request Timeout: execution expired" })
    end
  end

  def cache_key
    "country_info:country:#{country}" if country.present?
  end

  def handle_caching
    if cached = Rails.cache.fetch(cache_key)
      build_success_response(cached)
    else
      yield.tap do |result|
        if result.success?
          Rails.cache.write(cache_key, JSON[result.body], expires_in: CACHE_EXPIRATION)
          return build_success_response(JSON[result.body])
        end

        return build_error_response(JSON[result.body])
      end
    end
  end
end
