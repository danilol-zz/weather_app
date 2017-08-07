class WeatherReportsController < ApplicationController

  def index
    @report = WeatherReport.new(report_params).fetch
  end

  private

  def report_params
    params.permit(:city, :lat, :lon)
  end
end
