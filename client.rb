require 'google/apis/analyticsreporting_v4'
require 'pry'
class Client
  attr_reader :service, :credentials
  attr_accessor :page_token

  def initialize(page_token)
    @service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    @credentials = Google::Auth::ServiceAccountCredentials.make_creds(
      scope: "https://www.googleapis.com/auth/analytics.readonly"
    )
    @page_token = page_token
  end

  # Response from GA
  def response
    service.batch_get_reports(request)
  end

  # Get data from the response
  def responses
    response.reports.first.to_h
  end

  def next_page_token
    responses[:next_page_token]
  end

  def total_page_views
    responses[:data][:totals][0][:values][0]
  end

private
    
   # Set the date range - this is always required for report requests
  def date_range
    Google::Apis::AnalyticsreportingV4::DateRange.new(
      start_date: "2022-08-21",
      end_date: "2022-08-21"
    )
  end

  # Set the metric
  def metric
    Google::Apis::AnalyticsreportingV4::Metric.new(
      expression: "ga:uniquePageViews"
    )
  end

  #Set the pagePath dimension
  def dimension_path
    Google::Apis::AnalyticsreportingV4::Dimension.new(
      name: "ga:pagePath"
    )
  end

  #Set the pageTitle dimension
  def dimension_title
    Google::Apis::AnalyticsreportingV4::Dimension.new(
      name: "ga:pageTitle"
    )
  end

  # Build GA request
  def report_request
    Google::Apis::AnalyticsreportingV4::ReportRequest.new(
      view_id: 'ga:56562468',
      sampling_level: 'LARGE',
      date_ranges: [date_range],
      metrics: [metric],
      dimensions: [dimension_path, dimension_title],
      page_token: page_token,
      page_size: "1000"
    )
  end

  # Create a new report request
  def request
    service.authorization = credentials
    Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      { report_requests: [report_request] }
    )
  end
end