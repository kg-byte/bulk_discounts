require "rails_helper"

RSpec.describe Customer, type: :model do

  describe 'associations' do
	  it {should have_many :invoices}
    it { should have_many(:transactions).through(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}
  end

  describe 'class methods' do
    it '.top_5_customers' do
      cust1 = FactoryBot.create_list(:customer, 1, first_name: 'cust1')[0]
      cust2 = FactoryBot.create_list(:customer, 1, first_name: 'cust2')[0]
      cust3 = FactoryBot.create_list(:customer, 1, first_name: 'cust3')[0]
      cust4 = FactoryBot.create_list(:customer, 1, first_name: 'cust4')[0]
      cust5 = FactoryBot.create_list(:customer, 1, first_name: 'cust5')[0]
      cust6 = FactoryBot.create_list(:customer, 1, first_name: 'cust6')[0]
      cust7 = FactoryBot.create_list(:customer, 1, first_name: 'cust7')[0]


      invoice_1 = FactoryBot.create_list(:invoice, 1, customer: cust1, status: 2)[0]
      invoice_2 = FactoryBot.create_list(:invoice, 1, customer: cust2, status: 2)[0]
      invoice_3 = FactoryBot.create_list(:invoice, 1, customer: cust3, status: 2)[0]
      invoice_4 = FactoryBot.create_list(:invoice, 1, customer: cust4, status: 2)[0]
      invoice_5 = FactoryBot.create_list(:invoice, 1, customer: cust5, status: 2)[0]
      invoice_6 = FactoryBot.create_list(:invoice, 1, customer: cust6, status: 2)[0]
      invoice_7 = FactoryBot.create_list(:invoice, 1, customer: cust7, status: 2)[0]

      FactoryBot.create_list(:transaction, 6, result:0, invoice: invoice_7)
      FactoryBot.create_list(:transaction, 5, result:0, invoice: invoice_1)
      FactoryBot.create_list(:transaction, 4, result:0, invoice: invoice_6)
      FactoryBot.create_list(:transaction, 3, result:0, invoice: invoice_2)
      FactoryBot.create_list(:transaction, 2, result:0, invoice: invoice_4)
      FactoryBot.create_list(:transaction, 1, result:0, invoice: invoice_5)
      FactoryBot.create_list(:transaction, 1, result:0, invoice: invoice_3)
    
  
      expect(Customer.top_5_customers).to eq([cust7, cust1, cust6, cust2, cust4])
    end
  end


end
