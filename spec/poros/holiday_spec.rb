require 'rails_helper'


RSpec.describe Holiday do 
	it 'exists and has user_name and contributions' do 
		data = {name: 'Christmas', date: '12-25-2022'}
		holiday = Holiday.new(data)
		expect(holiday).to be_a Holiday
		expect(holiday.name).to eq 'Christmas'
		expect(holiday.date).to eq '12-25-2022'
	end


end