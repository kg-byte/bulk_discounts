require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do

  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:bulk_discounts).through(:item)}
    it { should have_many(:merchants).through(:item)}
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:unit_price).only_integer }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }

    let!(:status) { %i[packaged pending shipped]}
  end

  describe 'instance methods' do
    describe '.applied_discount' do 
      it 'returns the best applicable discount' do 
        merchant3 = FactoryBot.create_list(:merchant, 1)[0]
        item5 = FactoryBot.create_list(:item, 1, merchant: merchant3)[0]
        invoice4 = FactoryBot.create_list(:invoice, 1)[0]
        invoice_item5 = FactoryBot.create_list(:invoice_item, 1, item: item5, invoice: invoice4, unit_price: 1000, quantity: 15)[0]
        discount1 = merchant3.bulk_discounts.create!(quantity: 10, discount: 0.1)
        discount2 = merchant3.bulk_discounts.create!(quantity: 15, discount: 0.2)

        expect(invoice_item5.applied_discount).to eq(discount2)
      end
    end
  end

end
