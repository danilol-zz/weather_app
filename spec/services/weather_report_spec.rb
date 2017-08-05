require 'rails_helper'

describe WeatherReport do
  describe ".random_search", vcr: true do
    let(:weather_report) { described_class.new }

    before { weather_report.berlin_report }

    it "returns the Berlin weather" do
      expect(weather_report.response).to be_a HTTParty::Response
      expect(weather_report.response.success?).to be
      expect(weather_report.response["weather"][0]["main"]).to eq "Clouds"
    end
  end
end
