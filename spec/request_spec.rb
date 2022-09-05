require_relative '../google_analytics_client/request'

RSpec.describe Request do
  let(:request) { Request.new("0") }

  let(:expected_request) do
    {
      reportRequests: [
        {
          dateRanges: [
            {
              endDate: "2022-08-21", 
              startDate:"2022-08-21"
            }
          ],
          dimensions: [
            { name: "ga:pagePath" }, 
            { name: "ga:pageTitle" }
          ],
          metrics: [
            { expression: "ga:uniquePageViews" }
          ],
          pageSize: "1000",
          pageToken: "0",
          samplingLevel: "LARGE",
          viewId: "ga:56562468"
        }
      ]
    }
  end

  context "#initialize" do
    it "initializes with a page_token" do
      expect(request.page_token).to eql('0')
    end
  end

  context "#analytics_reports" do
    it "makes a request to the Google Analytics API" do
      expect(request.analytics_reports).to be_a(Google::Apis::AnalyticsreportingV4::GetReportsRequest)
    end

    it "correctly formats request" do
      expect(request.analytics_reports.to_json).to eql(expected_request.to_json)
    end
  end
end
