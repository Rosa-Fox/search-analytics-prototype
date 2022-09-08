
class WriteBulk
  attr_accessor :data
  def initialize(data)
    @data = data
  end

  def export  
    puts "exporting"
    File.open("all-page-traffic.dump", "w+") do |f|
      data.each { |element| f.puts(element) }
    end
  end
end