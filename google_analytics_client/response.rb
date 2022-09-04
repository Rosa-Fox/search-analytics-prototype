module Response
  # Response from GA
  def response
    service.batch_get_reports(request)
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