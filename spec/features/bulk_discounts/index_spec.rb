require "rails_helper"

RSpec.describe "merchants bulk discounts index page", type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")
  end

  it 'lists bulk discounts and their attributes' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
    bulk_discount2 = @merchant1.bulk_discounts.create!(quantity:25, discount:0.2)
    bulk_discount3 = @merchant2.bulk_discounts.create!(quantity:35, discount:0.25)

    visit merchant_bulk_discounts_path(@merchant1.id)

      expect(page).to have_content('10')
      expect(page).to have_content('15%')

      expect(page).to_not have_content('35')
      expect(page).to_not have_content('25%')
  end

  it 'has a link to the show page of each bulk discount' do 
    bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
    bulk_discount2 = @merchant1.bulk_discounts.create!(quantity:15, discount:0.2)
    bulk_discount3 = @merchant2.bulk_discounts.create!(quantity:20, discount:0.25)
    
    visit merchant_bulk_discounts_path(@merchant1.id)

    within("#bulk_discount-#{bulk_discount1.id}") do 
    
      click_link 'View Discount'

      expect(current_path).to eq merchant_bulk_discount_path(@merchant1.id, bulk_discount1.id)
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

    it 'has a link to delete each bulk discount' do 
      bulk_discount1 = @merchant1.bulk_discounts.create!(quantity:10, discount:0.15)
      bulk_discount2 = @merchant1.bulk_discounts.create!(quantity:25, discount:0.2)

      visit merchant_bulk_discounts_path(@merchant1.id)

      expect(page).to have_content('10')
      expect(page).to have_content('15%')
      expect(page).to have_content('25')
      expect(page).to have_content('20%')

      within("#bulk_discount-#{bulk_discount1.id}") do 
      
        click_link 'Delete'

        expect(current_path).to eq merchant_bulk_discounts_path(@merchant1.id)
      end

      expect(page).to_not have_content('10')
      expect(page).to_not have_content('15%')
      expect(page).to have_content('25')
      expect(page).to have_content('20%')
  end

  it 'lists the next 3 upcoming US holidays' do 
     visit merchant_bulk_discounts_path(@merchant1.id)

     holidays_data = HolidayService.new.get_holidays

     within("#upcoming_holidays") do 
      expect(page).to have_content(holidays_data[0][:name])
      expect(page).to have_content(holidays_data[0][:date])
      expect(page).to have_content(holidays_data[1][:name])
      expect(page).to have_content(holidays_data[1][:date])
      expect(page).to have_content(holidays_data[2][:name])
      expect(page).to have_content(holidays_data[2][:date])
      expect(page).to_not have_content(holidays_data[3][:name])
      expect(page).to_not have_content(holidays_data[3][:date])
     end
  end

  it 'has a link next to each holiday to create a holiday discount' do 
    visit merchant_bulk_discounts_path(@merchant1.id)

     holidays_data = HolidayService.new.get_holidays

     within("#upcoming_holidays") do 
      within("#holiday-1") do 
        click_link 'Create Holiday Discount'

        expect(current_path).to eq new_merchant_bulk_discount_path(@merchant1.id)
        
      end
     end


        fill_in 'quantity', with: 15
        fill_in 'discount', with: 0.10
        
        click_button 'Submit'
        expect(current_path).to eq merchant_bulk_discounts_path(@merchant1.id)
  end

  it 'shows a link to view holiday discount and no link to create if holiday discount has been created' do 

      visit merchant_bulk_discounts_path(@merchant1.id)

     holidays_data = HolidayService.new.get_holidays

     within("#upcoming_holidays") do 
      within("#holiday-1") do 
        click_link 'Create Holiday Discount'

        expect(current_path).to eq new_merchant_bulk_discount_path(@merchant1.id)
        
      end
     end


    fill_in 'quantity', with: 15
    fill_in 'discount', with: 0.10
    
    click_button 'Submit'
    expect(current_path).to eq merchant_bulk_discounts_path(@merchant1.id)
    bulk_discount_id = BulkDiscount.last.id
     within("#upcoming_holidays") do 
        within("#holiday-1") do 
          expect(page).to_not have_link 'Create Holiday Discount'
          expect(page).to have_link 'View Holiday Discount'
        
          click_link 'View Holiday Discount'

          expect(current_path).to eq merchant_bulk_discount_path(@merchant1.id, bulk_discount_id)
        end
      end
  end
end