require "rails_helper"

RSpec.describe "merchants bulk discounts new page", type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")
  end

  it 'can create new bulk discount' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)

    visit merchant_bulk_discounts_path(@merchant1.id)

    expect(page).to_not have_content('Quantity threshold: 20')
    expect(page).to_not have_content('20%')

    visit new_merchant_bulk_discount_path(@merchant1.id)

    fill_in 'quantity', with: 20
    fill_in 'discount', with: 0.2

    click_button 'Submit'

    expect(current_path).to eq merchant_bulk_discounts_path(@merchant1.id)
    expect(page).to have_content('20')
    expect(page).to have_content('20%')
  end

  it 'cannot create new bulk discount if it is not applicable with existing discounts' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)

    visit new_merchant_bulk_discount_path(@merchant1.id)

    fill_in 'quantity', with: 25
    fill_in 'discount', with: 0.10

    click_button 'Submit'

    expect(current_path).to eq new_merchant_bulk_discount_path(@merchant1.id)
    expect(page).to have_content('Unable to create this Bulk Discount as it is not applicable with other existing discounts!')

    visit merchant_bulk_discounts_path(@merchant1.id)
    expect(page).to_not have_content('25')
    expect(page).to_not have_content('10%')
  end

end