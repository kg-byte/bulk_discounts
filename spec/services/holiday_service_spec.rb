require 'rails_helper'

RSpec.describe HolidayService do 
	describe '.get(url) and get_holidays'  do 
		it 'gets and parses holiday url into a hash' do 
			holiday_url = HolidayService.new.get_url('https://date.nager.at/api/v3/NextPublicHolidays/US')
			expect(holiday_url).to be_an Array 
			expect(holiday_url.first.key?(:name)).to be true
		end
	end
end