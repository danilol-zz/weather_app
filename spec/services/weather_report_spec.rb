require 'rails_helper'

describe WeatherReport do
  let(:weather_report) { described_class.new(options) }

  context ".fetch", vcr: { record: :once } do
    context "by city" do
      context "when the city exists" do
        let(:options) { { city: "Berlin" } }

        before { weather_report.fetch }

        it "returns the city weather" do
          expect(weather_report.response).to be_a OpenStruct
          expect(weather_report.response.success?).to be true
          expect(weather_report.response.city).to           eq "Berlin"
          expect(weather_report.response.weather[:main]).to eq "Clear"
        end
      end

      context "when the city doesn't exist" do
        let(:options) { { city: "12312212121" } }

        before { weather_report.fetch }

        it "returns the city weather" do
          expect(weather_report.response).to be_a OpenStruct
          expect(weather_report.response.success?).to be false
          expect(weather_report.response.cod).to      eq "404"
          expect(weather_report.response.message).to  eq "city not found"
        end
      end
    end

    context "by geolocation" do
      let(:options) { { lat: "-23.43", lon: -45.07 } }

      before { weather_report.fetch }

      it "returns the Berlin weather" do
        expect(weather_report.response).to be_a OpenStruct
        expect(weather_report.response.success?).to be true
        expect(weather_report.response.city).to           eq "Ubatuba"
        expect(weather_report.response.weather[:main]).to eq "Clear"
      end
    end

    context "by coordinates" do
      let(:options) { { } }

      before do
        allow(weather_report).to receive(:rand_lat).and_return(27.33)
        allow(weather_report).to receive(:rand_lon).and_return(98.09)
        weather_report.fetch
      end

      it "returns Random weather" do
        expect(weather_report.response).to be_a OpenStruct
        expect(weather_report.response.success?).to be true
        expect(weather_report.response.city).to           eq "Cikai"
        expect(weather_report.response.weather[:main]).to eq "Rain"
      end
    end
  end
end
