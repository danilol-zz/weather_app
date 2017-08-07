require 'rails_helper'

describe WeatherReport do
  let(:weather_report) { described_class.new(options) }

  context ".fetch", vcr: { record: :once } do
    subject { weather_report.response }

    context "by city" do
      context "when the city exists" do
        let(:options) { { city: "Berlin" } }

        before { weather_report.fetch }

        it "returns the city weather" do
          expect(subject).to be_a OpenStruct
          expect(subject.success?).to be true
          expect(subject.code).to           eq "200"
          expect(subject.city).to           eq "Berlin"
          expect(subject.weather[:main]).to eq "Clear"
        end
      end

      context "when the city doesn't exist" do
        let(:options) { { city: "12312212121" } }

        before { weather_report.fetch }

        it "returns the city weather" do
          expect(subject).to be_a OpenStruct
          expect(subject.success?).to be false
          expect(subject.code).to      eq "404"
          expect(subject.message).to  eq "city not found"
        end
      end
    end

    context "by geolocation" do
      let(:options) { { lat: "-23.43", lon: -45.07 } }

      before { weather_report.fetch }

      it "returns the Berlin weather" do
        expect(subject).to be_a OpenStruct
        expect(subject.success?).to be true
        expect(subject.code).to           eq "200"
        expect(subject.city).to           eq "Ubatuba"
        expect(subject.weather[:main]).to eq "Clear"
      end
    end

    context "by random location" do
      let(:options) { { } }

      before do
        allow(weather_report).to receive(:rand_lat).and_return(27.33)
        allow(weather_report).to receive(:rand_lon).and_return(98.09)
        weather_report.fetch
      end

      it "returns Random weather" do
        expect(subject).to be_a OpenStruct
        expect(subject.success?).to be true
        expect(subject.code).to           eq "200"
        expect(subject.city).to           eq "Cikai"
        expect(subject.weather[:main]).to eq "Rain"
      end
    end

    context "when request reaches timeout" do
      let(:options) { { city: "Berlin" } }

      before { weather_report.fetch }

      it "returns Random weather" do
        pending
        expect(subject).to be_a OpenStruct
        expect(subject.success?).to be false
        expect(subject.code).to     eq "408"
        expect(subject.message).to  eq "Request Timeout: execution expired"
      end
    end
  end
end
