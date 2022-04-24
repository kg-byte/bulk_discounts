require 'rails_helper'

RSpec.describe HolidayFacade do 
	before :each do 
		@holiday_facade = HolidayFacade.new
	end

	describe '.service' do 
		it 'creates an instance of holidayservice' do 
			expect(@holiday_facade.service).to be_a HolidayService
		end
	end

	describe '.holidays_data' do 
		it 'renders holidays_data as an array of holidays' do 
			expect(@holiday_facade.holidays_data).to be_an Array 
			expect(@holiday_facade.holidays_data.first.key?(:date)).to eq true
		end
	end

	describe '.create_holidays' do 
		it 'creates instances of holidays' do 
			expect(@holiday_facade.create_holidays).to be_an Array 
			expect(@holiday_facade.create_holidays.first).to be_a Holiday 
		end
	end
end