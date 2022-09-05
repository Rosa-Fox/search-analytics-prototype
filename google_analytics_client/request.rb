class Request
   # Set the date range - this is always required for report requests
  attr_accessor :page_token
  def initialize(page_token)
    @page_token = page_token
  end

  # Create a new report request
  def analytics_reports
    Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      { report_requests: [build] }
    )
  end

private

  # Build GA request
  def build
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
end