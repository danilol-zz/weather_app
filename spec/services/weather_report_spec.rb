require 'rails_helper'

describe WeatherReport do
  let(:weather_report) { described_class.new(options) }

  context "By City report", vcr: true do
    let(:options) { { city: "Berlin" } }

    before { weather_report.fetch }

    it "returns the Berlin weather" do
      expect(weather_report.response).to be_a HTTParty::Response
      expect(weather_report.response.success?).to be true
      expect(weather_report.response["weather"][0]["main"]).to eq "Clear"
    end
  end

  context ".random_search", vcr: true do
    let(:options) { { } }

    before do
      allow(weather_report).to receive(:rand_lat).and_return(27.33)
      allow(weather_report).to receive(:rand_lon).and_return(98.09)
      weather_report.fetch
    end

    it "returns the Berlin weather" do
      expect(weather_report.response).to be_a HTTParty::Response
      expect(weather_report.response.success?).to be true
      expect(weather_report.response["name"]).to               eq "Cikai"
      expect(weather_report.response["weather"][0]["main"]).to eq "Rain"
    end
  end
end
