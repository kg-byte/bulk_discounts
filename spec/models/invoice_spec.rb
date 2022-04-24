require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }

  end

  describe "validations" do
    let!(:status) { %i[cancelled in_progress completed] }
  end

  describe "instance methods" do

    before :each do
      @merchant1 = Merchant.create!(name: "Schroeder-Jerde")
      @item1 = @merchant1.items.create!(name: "Item Qui Esse", description: "Nihil autem sit odio inventore deleniti. Est lauda...", unit_price: 75107)
      @item2 = @merchant1.items.create!(name: "Item Autem Minima", description: "Cumque consequuntur ad. Fuga tenetur illo molestia...", unit_price: 67076)
      @item3 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "Sunt officia eum qui molestiae. Nesciunt quidem cu...", unit_price: 32301)
      @customer1 = Customer.create!(first_name: "Joey", last_name: "Ondricka")
      @invoice1 = Invoice.create!(customer_id: @customer1.id, status: "cancelled")
      @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 75100, status: "shipped",)
      @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice1.id, quantity: 3, unit_price: 200000, status: "packaged",)
    end


    describe '.total_revenue' do 
      it 'calculates the total revenue on this invoice' do 
        expect(@invoice1.total_revenue).to eq(6751.00)
      end
    end

    describe '.discounted_revenue' do 
      it 'calculates the discounted revenue on this invoice' do 
        merchant3 = FactoryBot.create_list(:merchant, 1)[0]
        merchant4 = FactoryBot.create_list(:merchant, 1)[0]
        item5 = FactoryBot.create_list(:item, 1, merchant: merchant3)[0]
        item6 = FactoryBot.create_list(:item, 1, merchant: merchant4)[0]
        invoice4 = FactoryBot.create_list(:invoice, 1)[0]
        invoice_item5 = FactoryBot.create_list(:invoice_item, 1, item: item5, invoice: invoice4, unit_price: 1000, quantity: 20)
        invoice_item6 = FactoryBot.create_list(:invoice_item, 1, item: item5, invoice: invoice4, unit_price: 1000, quantity: 10)
        invoice_item7 = FactoryBot.create_list(:invoice_item, 1, item: item5, invoice: invoice4, unit_price: 1000, quantity: 8)
        invoice_item8 = FactoryBot.create_list(:invoice_item, 1, item: item6, invoice: invoice4, unit_price: 1000, quantity: 10)
        merchant3.bulk_discounts.create!(quantity: 10, discount: 0.1)
        merchant3.bulk_discounts.create!(quantity: 15, discount: 0.2)
        merchant3.bulk_discounts.create!(quantity: 20, discount: 0.15)
        merchant4.bulk_discounts.create!(quantity: 10, discount: 0.05)

        expect(invoice4.discounted_revenue).to eq(425.0)
      end
    end
  end


  describe "class methods" do
    describe '#not_completed' do 
      it "can return all invoices that are incomplete aka 'in progress'" do
        customer_1 = Customer.create!(first_name: "Burt", last_name: "Bacharach")

        invoice_1 = customer_1.invoices.create!(status: "in progress")
        invoice_2 = customer_1.invoices.create!(status: "in progress")
        invoice_3 = customer_1.invoices.create!(status: "cancelled")
        invoice_4 = customer_1.invoices.create!(status: "completed")
        invoice_5 = customer_1.invoices.create!(status: "completed")

        expect(customer_1.invoices.not_completed).to eq([invoice_1, invoice_2])
      end
  end
 end
end

