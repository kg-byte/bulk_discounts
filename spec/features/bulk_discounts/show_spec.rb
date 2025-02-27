require "rails_helper"

RSpec.describe "merchants bulk discount show page", type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")
  end

  it 'lists bulk discounts and their attributes' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
    bulk_discount2 = @merchant1.bulk_discounts.create!(quantity:18, discount:0.2)
    bulk_discount3 = @merchant2.bulk_discounts.create!(quantity:25, discount:0.25)

    visit merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)

    expect(page).to have_content('10')
    expect(page).to have_content('15%')
    expect(page).to_not have_content('18')
    expect(page).to_not have_content('20%')
    expect(page).to_not have_content('25')
    expect(page).to_not have_content('25%')
  end

  it 'has a link to edit the bulk discount' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
    
    visit merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)

    click_link 'Edit Bulk Discount'

    expect(current_path).to eq edit_merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)
  end

end