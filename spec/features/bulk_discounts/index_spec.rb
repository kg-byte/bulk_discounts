require "rails_helper"

RSpec.describe "merchants bulk discounts index page", type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")
  end

  it 'lists bulk discounts and their attributes' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
    bulk_discount2 = @merchant1.bulk_discounts.create!(quantity:15, discount:0.2)
    bulk_discount3 = @merchant2.bulk_discounts.create!(quantity:20, discount:0.25)

    visit merchant_bulk_discounts_path(@merchant1.id)

      expect(page).to have_content('Quantity threshold: 10, Percentage discount: 15%')
      expect(page).to have_content('Quantity threshold: 15, Percentage discount: 20%')
      expect(page).to_not have_content('Quantity threshold:20, Percentage discount: 25%')
  end

  it 'has a link to the show page of each bulk discount' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
    bulk_discount2 = @merchant1.bulk_discounts.create!(quantity:15, discount:0.2)
    bulk_discount3 = @merchant2.bulk_discounts.create!(quantity:20, discount:0.25)
    
    visit merchant_bulk_discounts_path(@merchant1.id)

    within("#bulk_discount-#{bulk_discount1.id}") do 
    
      click_link 'Go to This Discount'

      expect(current_path).to eq bulk_discount_path(bulk_discount1.id)
    end
  end

  it 'has a link to create new bulk discount' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
    bulk_discount2 = @merchant1.bulk_discounts.create!(quantity:15, discount:0.2)
    bulk_discount3 = @merchant2.bulk_discounts.create!(quantity:20, discount:0.25)
    

    visit merchant_bulk_discounts_path(@merchant1.id)

    click_link 'New Bulk Discount'

    expect(current_path).to eq new_merchant_bulk_discount_path(@merchant1.id)

  end

end