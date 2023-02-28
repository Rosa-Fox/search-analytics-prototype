require_relative '../google_analytics_service'
require 'google/apis/analyticsreporting_v4'
require 'pry'

RSpec.describe GoogleAnalyticsService do
  let(:google_analytics_service) { GoogleAnalyticsService.new }

  let(:two_pages) { [ { base_path: "/", page_views: "120000"}, { base_path: "/random", page_views: "120"} ] }

  let(:build_response) { Google::Apis::AnalyticsreportingV4::GetReportsResponse.new(
        reports: [
          Google::Apis::AnalyticsreportingV4::Report.new(
            data: Google::Apis::AnalyticsreportingV4::ReportData.new(
              totals: [ { values: [ 120120 ] } ],
              rows:
                two_pages.map do |response|
                  Google::Apis::AnalyticsreportingV4::ReportRow.new(
                    dimensions: [
                      response.fetch(:base_path)
                    ],
                    metrics: [
                      Google::Apis::AnalyticsreportingV4::DateRangeValues.new(
                        values: [
                          response.fetch(:page_views)
                        ]
                      )
                    ]
                  )
                end
            ),
            next_page_token: "1000"
          )
        ]
      )
    }

  #initialising client
  before do
    @google_private_key = ENV['GOOGLE_PRIVATE_KEY']
    ENV['GOOGLE_PRIVATE_KEY'] = "key"
    @google_client_email = ENV['GOOGLE_CLIENT_EMAIL']
    ENV['GOOGLE_CLIENT_EMAIL'] = "test@test.com"
    allow(OpenSSL::PKey::RSA).to receive(:new).and_return("key")
  end

  after do
    ENV["GOOGLE_PRIVATE_KEY"] = @google_private_key
    ENV["GOOGLE_CLIENT_EMAIL"] = @google_client_email
  end

  context "#initialize" do
    it "initializes with a client" do
      google_analytics_service = GoogleAnalyticsService.new
      expect(google_analytics_service.client).to be_a Client
    end

    it "initializes with empty all_data array" do
      expect(google_analytics_service.all_data).to eql([])
    end
  end

  context "#response" do
    it "gets response" do
      google_client = double('client')
      allow(google_analytics_service).to receive_message_chain(:client, :service).and_return(google_client)
      allow(google_client).to receive(:batch_get_reports).and_return(build_response)
  
      expect(google_analytics_service.response("0")).to be_a Response
      expect(google_analytics_service.response("0").ga_response.reports[0].data.rows.first.dimensions).to eql(["/"])
    end
  end

  context "#get_ga_data" do
    it "returns responses from all pages" do
      #
    end 
  end
end
