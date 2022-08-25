class Normalise
  attr_accessor :data
  def initialize(data)
    @data = data
  end

  def normalise_data
    normalised_data = []

    formatted_ga_data.each do |data|
      path = data[:page_path]
      if starts_with_slash_and_is_not_a_smart_answer(path)
         path = remove_query_string(path)
         replace_empty_string_with_slash(path)
         unless page_not_found(data)
           normalised_data << normalised_row_data(data, path)
         end
      end
    end
    sort_normalised_data(normalised_data)
  end

private

  # Pull out the relevant data from the API response
  def formatted_ga_data
    page_data = []
    data.each do |page_of_data|
      page_of_data[:data][:rows].each do |row|
        row_data = {
          unique_page_views: row[:metrics][0][:values][0],
          page_path: row[:dimensions][0],
          page_title: row[:dimensions][1]
        }
        page_data << row_data
      end
    end
    page_data
  end

  def starts_with_slash_and_is_not_a_smart_answer(path)
    path.start_with?('/') && !path.include?('/y/')
  end

  def remove_query_string(path)
    path.split('?')[0].strip
  end

   # Special case so that / isn't represented as an empty string
  def replace_empty_string_with_slash(path)
    if path.length == 0
      path = '/'
    end
  end

  def page_not_found(data)
    data[:page_title] == "Page not found - GOV.UK"
  end

  def normalised_row_data(data, path)
    {
      unique_page_views: data[:unique_page_views],
      page_path: path,
      page_title: data[:page_title]
    }
  end

  def sort_normalised_data(normalised_data)
    normalised_data.flatten!
    normalised_data.sort_by! { |k| k[:unique_page_views].to_i }
    normalised_data.reverse! 
    normalised_data.uniq!
  end
end