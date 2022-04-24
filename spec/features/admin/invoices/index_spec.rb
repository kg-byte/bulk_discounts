require 'rails_helper'

RSpec.describe 'admin invoices index page' do
  it 'shows all the invoices with a link to their show page' do
    @customer = Customer.create(first_name: "Sally", last_name: "Jones")

    @invoice1 = @customer.invoices.create!(status: 0)
    @invoice2 = @customer.invoices.create!(status: 1)
    @invoice3 = @customer.invoices.create!(status: 0)
    @invoice4 = @customer.invoices.create!(status: 2)
    @invoice5 = @customer.invoices.create!(status: 1)

    Invoice.all.each do |invoice|
      visit "/admin/invoices"
      click_on("#{invoice.id}")
      expect(current_path).to eq("/admin/invoices/#{invoice.id}")
    end
  end


  it 'shows a link to the applied bulk discount if applicable and when invoice is marked completed' do 
    merchant3 = FactoryBot.create_list(:merchant, 1)[0]
    item5 = FactoryBot.create_list(:item, 1, merchant: merchant3)[0]
    invoice4 = FactoryBot.create_list(:invoice, 1)[0]
    invoice_item5 = FactoryBot.create_list(:invoice_item, 1, item: item5, invoice: invoice4, unit_price: 1000, quantity: 15)[0]
    discount1 = merchant3.bulk_discounts.create!(quantity: 10, discount: 0.1)
    discount2 = merchant3.bulk_discounts.create!(quantity: 15, discount: 0.2)

    visit "/merchants/#{merchant3.id}/invoices/#{invoice4.id}"

    within("#invoice_item-#{invoice_item5.id}") do 
      click_link 'Applied Bulk Discount'
      expect(current_path).to eq merchant_bulk_discount_path(merchant3.id, discount2.id)
    end
  end
end
