require_relative 'client'
require 'pry'

class Fetch
  attr_reader :client
  def initialize
    @client = Client.new
  end

  def get_ga_data
    puts client.responses
  end
end

fetch = Fetch.new 
fetch.get_ga_data