require 'google/apis/analyticsreporting_v4'

class Client
  attr_reader :service, :credentials
  attr_accessor :page_token

  def initialize()
    @service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    @credentials = Google::Auth::ServiceAccountCredentials.make_creds(
      scope: "https://www.googleapis.com/auth/analytics.readonly"
    )
    @service.authorization = @credentials
  end
end