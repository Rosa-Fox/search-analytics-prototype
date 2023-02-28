require_relative '../google_analytics_client/client'
require 'pry'

RSpec.describe Client do
  let(:json_key) { { client_email: "test@test.com", private_key: "key" } }
  let(:client) { Client.new }

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

  context "initialize" do
    it "creates a service" do
      expect(client.service).to be_a(Google::Apis::AnalyticsreportingV4::AnalyticsReportingService)
    end

    it "creates credentials" do
      expect(client.credentials).to be_a(Google::Auth::ServiceAccountCredentials)
    end
  end

  context "setting up authorization" do
    it "uses the given client email from the json key" do
      expect(client.credentials.issuer).to eq("test@test.com")
    end

    it "uses the given private key the json key" do
      expect(client.credentials.signing_key).to eq("key")
    end

    it "uses the given scope" do
      expect(client.credentials.scope).to eq(["https://www.googleapis.com/auth/analytics.readonly"])
    end
  end
end