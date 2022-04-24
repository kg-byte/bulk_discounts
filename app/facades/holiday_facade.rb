require_relative "../services/holiday_service"
require_relative "../poros/holiday"

class HolidayFacade


  def create_holidays
    holidays_data.map do |data|
      Holiday.new(data)
    end
  end

  def service
    @_service ||= HolidayService.new
  end

  def holidays_data
    @_holiday_data ||=service.get_holidays
  end
end
