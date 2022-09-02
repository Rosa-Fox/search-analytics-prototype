class Rank
  attr_accessor :data, :total_page_views
  def initialize(data, total_page_views)
    @data = data
    @total_page_views = total_page_views
  end

  def relevance
    formatted = []
    data.each.with_index(1) do |value, index|
       path =  {
        index: {
          _type: "page-traffic",
          _id: value[:page_path]
        }
      }
      rank = {
        path_components: [value[:page_path]],
        rank_1: index,
        vc_1: value[:unique_page_views],
        vf_1: value[:unique_page_views].to_f  / total_page_views.to_f
      }
      formatted << path.to_json
      formatted << rank.to_json
    end
    formatted
  end
end