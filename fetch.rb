require_relative 'client'
require 'pry'

class Fetch
  attr_reader :client
  def initialize
    @client = Client.new("0")
  end

  def get_ga_data(page_token)
    client = Client.new(page_token)
    client.service.authorization = client.credentials

    page_token = client.response.reports.first.to_h[:next_page_token]

    #Setting 4000 in development to get 4 pages of data
    #Easier to work with for now...
    unless page_token > "4000"
      get_ga_data(page_token)
    end
  end
end

fetch = Fetch.new 
fetch.get_ga_data("0")