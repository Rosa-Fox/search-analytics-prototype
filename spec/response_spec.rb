require_relative '../google_analytics_client/response'

RSpec.describe Response do
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

    
  let(:response) { Response.new(build_response) }

  context "#initialize" do
    it "initializes with a response" do
      expect(response.ga_response).to be_a(Google::Apis::AnalyticsreportingV4::GetReportsResponse)
    end
  end

  context "#responses" do
    it "gets the GA report responses" do
      expected_response = {
        :data=> {  
          :rows=> [
            {:dimensions=>["/"], :metrics=>[{:values=>["120000"]} ]},
            {:dimensions=>["/random"], :metrics=>[{:values=>["120"]}]}
          ],
          :totals=>[
            {:values=>[120120]}
          ]
        },
        :next_page_token=>"1000"
      }
      
      expect(response.responses).to eql(expected_response) 
    end
  end

  context "#next_page_token" do
    it "gets the next_page_token from the response" do
      expect(response.next_page_token).to eql("1000") 
    end
  end

  context "#total_page_views" do
    it "gets the total_page_views from the response" do
      expect(response.total_page_views).to eql(120120) 
    end
  end
end