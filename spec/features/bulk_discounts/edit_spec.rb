require "rails_helper"

RSpec.describe "merchants bulk discounts edit page", type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")
  end

  it 'can edit an bulk discount' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)

    visit merchant_bulk_discounts_path(@merchant1.id, bulk_discount1.id)

    expect(page).to_not have_content('Quantity threshold: 20')
    expect(page).to_not have_content('20%')    
    expect(page).to have_content('Quantity threshold: 10')
    expect(page).to have_content('15%')

    visit edit_merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)

    fill_in 'quantity', with: 20
    fill_in 'discount', with: 0.2

    click_button 'Save'

    expect(current_path).to eq merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)
    expect(page).to have_content('Quantity threshold: 20')
    expect(page).to have_content('20%')
    expect(page).to_not have_content('Quantity threshold: 15')
    expect(page).to_not have_content('15%')
  end

    it 'cannot update bulk discount if it is not applicable with existing discounts' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
    bulk_discount2 = @merchant1.bulk_discounts.create!(quantity:20, discount:0.25)

     visit edit_merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)

    fill_in 'quantity', with: 20
    fill_in 'discount', with: 0.2

    click_button 'Save'
    expect(current_path).to eq edit_merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)
    expect(page).to have_content('Unable to update this Bulk Discount as it is not applicable with current other discounts!')
    visit merchant_bulk_discounts_path(@merchant1.id)

    expect(page).to_not have_content('Percentage discount: 20%')
    expect(page).to have_content('Percentage discount: 15%')
    expect(page).to have_content('Percentage discount: 25%')
    expect(page).to have_content('Quantity threshold: 10')
    expect(page).to have_content('Quantity threshold: 20', count: 1)

  end


end