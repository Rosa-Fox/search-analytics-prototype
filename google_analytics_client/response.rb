class Response
  # Response from GA
  attr_reader :response
  def initialize(response)
    @response = response
  end

  # Get data from the response
  def responses
    response.reports.first.to_h
  end

  def next_page_token
    responses[:next_page_token]
  end

  def total_page_views
    responses[:data][:totals][0][:values][0]
  end
end