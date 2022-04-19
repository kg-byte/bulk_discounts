require 'rails_helper'

RSpec.describe 'all index, show, edit, new pages' do 
	it 'shows the team members usernames' do 
		merchant = FactoryBot.create_list(:merchant,1)[0]
		invoice = FactoryBot.create_list(:invoice, 1)[0]
		item = FactoryBot.create_list(:item, 1, merchant: merchant)[0]
		urls = ['/admin/merchants', '/admin/invoices', 
				"/merchants/#{merchant.id}/dashboard", "/merchants/#{merchant.id}/items", 
				"/merchants/#{merchant.id}/items/#{item.id}",
				"/admin/merchants/#{merchant.id}", "/admin/invoices/#{invoice.id}"]

		urls.each do |url|
			visit url 
			
			within("#footer") do 
			expect(page).to have_content('sueboyd922')
				expect(page).to have_content('kg-byte')
				expect(page).to have_content('AliciaWatt')
				expect(page).to have_content('CoryBethune')
			end
		end 
	end
end