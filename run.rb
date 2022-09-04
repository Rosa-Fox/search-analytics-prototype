require 'dotenv/load'
require_relative 'fetch'
require_relative 'rank'
require_relative 'normalise'
require_relative 'write_bulk'


class Run
  attr_accessor :fetch

  def initialize
    @fetch = Fetch.new
  end

  def export_data  
    all_data = fetch.get_ga_data("0")
    
    ranked_data = rank(normalise(all_data), fetch.client.total_page_views)

    write_bulk(ranked_data)
  end

private 

  def normalise(all_data)
    normalise = Normalise.new(all_data)
    normalise.normalise_data
  end

  def rank(normalised_data, total_page_views)
    rank = Rank.new(normalised_data, total_page_views)
    rank.relevance
  end

  def write_bulk(ranked_data)
    write_bulk = WriteBulk.new(ranked_data) 
    write_bulk.export
  end
end

run = Run.new 
run.export_data


