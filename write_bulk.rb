
class WriteBulk
  attr_accessor :data
  def initialize(data)
    @data = data
  end

  def export  
    File.open("page-traffic.dump", "w+") do |f|
      data.each { |element| f.puts(element) }
    end
  end
end