require './app/poro/holiday'
require './app/service/esty_service'

class HolidaySearch
  def self.holiday_information
    EstyService.new.upcoming_holiday_response.first(3).map {|data| Holiday.new(data)}
  end
end