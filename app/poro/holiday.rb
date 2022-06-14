require 'date'
class Holiday
  attr_reader :name, :date

  def initialize(parsed_holiday)
    @date = DateTime.parse(parsed_holiday[:date]).strftime("%B %d, %Y")
    @name = parsed_holiday[:localName]
  end

end