require "rails_helper"

RSpec.describe "merchants bulk discounts edit page", type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")
  end

  it 'can edit an bulk discount' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)

    visit merchant_bulk_discounts_path(@merchant1.id, bulk_discount1.id)

    expect(page).to_not have_content(20)
    expect(page).to_not have_content('20%')    
    expect(page).to have_content(15)
    expect(page).to have_content('15%')

    visit edit_merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)

    fill_in 'quantity', with: 20
    fill_in 'discount', with: 0.2

    click_button 'Save'

    expect(current_path).to eq merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)
    expect(page).to have_content(20)
    expect(page).to have_content('20%')
    expect(page).to_not have_content(15)
    expect(page).to_not have_content('15%')
  end

end