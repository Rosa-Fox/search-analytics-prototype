require 'google/apis/analyticsreporting_v4'
require 'pry'
require_relative 'request'
require_relative 'response'

class Client
  include Request
  include Response

  attr_reader :service, :credentials
  attr_accessor :page_token

  def initialize(page_token)
    @service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    @credentials = Google::Auth::ServiceAccountCredentials.make_creds(
      scope: "https://www.googleapis.com/auth/analytics.readonly"
    )
    @page_token = page_token
  end
end