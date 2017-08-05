class WeatherReportsController < ActionController::Base

  def index
    @report = WeatherReport.new.berlin_report
  end
end
