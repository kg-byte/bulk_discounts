require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do

  describe 'associations' do
	it {should belong_to :merchant}
  it {should have_many(:invoices).through(:merchant)}
  # it {should have_many(:invoice_items).through(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:quantity).is_greater_than(0) } 
    it { should validate_presence_of(:discount) }
    it { should validate_numericality_of(:discount).is_greater_than_or_equal_to(0.01) }
    it { should validate_numericality_of(:discount).is_less_than_or_equal_to(0.99) }
  end

  describe 'instance methods' do 
    describe '.updatable?' do 
      it 'returns true when there are not pending invoices' do 
        Invoice.destroy_all
        merchant1 = FactoryBot.create_list(:merchant,1)[0]
        item1 = FactoryBot.create_list(:item, 1, merchant: merchant1)[0]
        invoice1 = FactoryBot.create_list(:invoice, 1, status: 0)[0]
        invoice2 = FactoryBot.create_list(:invoice, 1, status: 1)[0]
        invoice3 = FactoryBot.create_list(:invoice, 1, status: 2)[0]
        FactoryBot.create_list(:invoice_item, 1, invoice: invoice1, item: item1, quantity: 5)
        FactoryBot.create_list(:invoice_item, 1, invoice: invoice2, item: item1, quantity: 10)
        FactoryBot.create_list(:invoice_item, 1, invoice: invoice3, item: item1, quantity: 20)
        bulk_discount1 = merchant1.bulk_discounts.create(quantity: 5, discount: 0.05)
        bulk_discount2 = merchant1.bulk_discounts.create(quantity: 10, discount: 0.1)
        bulk_discount3 = merchant1.bulk_discounts.create(quantity: 20, discount: 0.2)
    
        expect(bulk_discount1.updatable?).to be true
        expect(bulk_discount2.updatable?).to be false
        expect(bulk_discount3.updatable?).to be true
      end
    end
  end

    describe 'class methods' do 
      describe '#applicable?' do 
          it 'checks whether the params will create an applicable discount with existing discounts' do 
            merchant1 = FactoryBot.create_list(:merchant,1)[0]
            item1 = FactoryBot.create_list(:item, 1, merchant: merchant1)[0]
            BulkDiscount.destroy_all
            bulk_discount1 = merchant1.bulk_discounts.create(quantity: 5, discount: 0.05)
            bulk_discount2 = merchant1.bulk_discounts.create(quantity: 10, discount: 0.1)
            bulk_discount3 = merchant1.bulk_discounts.create(quantity: 20, discount: 0.2)
            params1 = {quantity: 15, discount: 0.1, merchant_id: merchant1.id}
            params2 = {quantity: 15, discount: 0.2, merchant_id: merchant1.id}
            params3 = {quantity: 20, discount: 0.2, merchant_id: merchant1.id}
            expect(BulkDiscount.applicable?(params1)).to eq false
            expect(BulkDiscount.applicable?(params2)).to eq true
            expect(BulkDiscount.applicable?(params3)).to eq false
      end
    end

    describe '#find_holiday_discount_id' do 
      it 'returns holiday discount id if found' do 
          merchant1 = FactoryBot.create_list(:merchant,1)[0]
          bulk_discount1 = merchant1.bulk_discounts.create(name: 'Christmas Discount', quantity: 5, discount: 0.05)
          expect(BulkDiscount.find_holiday_discount_id('Christmas Discount')).to eq(bulk_discount1.id)
      end
    end
  end
end