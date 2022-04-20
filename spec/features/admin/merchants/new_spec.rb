require 'rails_helper'

RSpec.describe 'The admin merchant new' do

  # before :each do
  #   @merchant1 = FactoryBot.create_list(:merchant, 1)[0]
  #   @merchant2 = FactoryBot.create_list(:merchant, 1)[0]
  #   @merchant3 = FactoryBot.create_list(:merchant, 1)[0]
  # end

  it "has a link to add a new merchant" do
    visit "admin/merchants"
    expect(page).to have_link("Create New Merchant")

    click_link("Create New Merchant")
    expect(current_path).to eq "/admin/merchants/new"
  end

  it "has a form to create a new merchant and displays the new merchant on the admin index" do
    visit "/admin/merchants/new"

    fill_in("Name", :with => "Cory")
    click_button("Submit")
    expect(current_path).to eq "/admin/merchants"
    
    expect(page).to have_content("Merchant Name: Cory")
    expect(page).to have_content("Merchant Status: disabled")


  end

end
