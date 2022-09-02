require_relative 'client'

class Fetch
  attr_accessor :client, :all_data
  def initialize
    @client = Client.new("0")
    @all_data = []
  end

  def get_ga_data(page_token)
    client = Client.new(page_token)
    client.service.authorization = client.credentials

    # Build up a collection of all data so that
    # ranking can be calculated on all of the data
    # not just per results on each individual page
    all_data << client.responses

    page_token = client.next_page_token

    #Setting 4000 in development to get 4 pages of data
    #Easier to work with for now...
    unless page_token > "4000"
      get_ga_data(page_token)
    end
    all_data
  end
end

