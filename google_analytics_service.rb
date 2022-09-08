require_relative 'google_analytics_client/client'
require_relative 'google_analytics_client/request'
require_relative 'google_analytics_client/response'

class GoogleAnalyticsService
  attr_accessor :client, :all_data
  def initialize
    @client = Client.new
    @all_data = []
  end

  def response(page_token)
    request = Request.new(page_token)
    ga_response = client.service.batch_get_reports(request.analytics_reports)
    Response.new(ga_response)
  end

  def get_ga_data(page_token)
    

    # Build up a collection of all data so that
    # ranking can be calculated on all of the data
    # not just per results on each individual page

    request = Request.new(page_token)
    ga_response = client.service.batch_get_reports(request.analytics_reports)
    a_response = Response.new(ga_response)

    all_data << a_response.responses

    page_token = a_response.next_page_token

    #Setting 4000 in development to get 4 pages of data
    #Easier to work with for now...
    if page_token.to_i <= 59000
      puts page_token
      get_ga_data(page_token)
    end
    all_data
  end
end

