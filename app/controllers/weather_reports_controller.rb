class WeatherReportsController < ActionController::Base

  def index
    #@report = WeatherReport.new.berlin_report
    #@report = WeatherReport.new.random_report

    @report = WeatherReport.new(report_params).report
  end

  private

  def report_params
    params.permit(:city)
  end
end
