require "rails_helper"

RSpec.describe "the admin dashboard" do
  it "shows a header to the dashboard" do
    visit "/admin"

    expect(page).to have_content("Welcome to Admin Dashboard")
  end

  it "shows links to access merchant and invoice index" do
    visit "/admin"

    expect(page).to have_link("Merchants Index")
    expect(page).to have_link("Invoices Index")
  end

  it "has a list of all incompleted invoices with their ID, which is a link to its show page" do
    customer_1 = Customer.create!(first_name: "John", last_name: "Smith")

    invoice_1 = customer_1.invoices.create!(status: "in progress")
    invoice_2 = customer_1.invoices.create!(status: "in progress")
    invoice_3 = customer_1.invoices.create!(status: "completed")
    invoice_4 = customer_1.invoices.create!(status: "cancelled")

    visit "/admin"

    within("#incompleted_invoices") do
      expect(page).to have_content(invoice_1.id)
      expect(page).to have_content(invoice_2.id)
      expect(page).to_not have_content(invoice_3.id)
      expect(page).to_not have_content(invoice_4.id)
      expect(page).to have_link("Invoice: #{invoice_2.id}")
    end
  end

  it "list of incompleted invoices is ordered from least recent to most recent" do
    customer_1 = Customer.create!(first_name: "Person 1", last_name: "Mcperson 1")

    invoice_1 = customer_1.invoices.create!(status: "in progress", created_at: "2022-04-10")
    invoice_2 = customer_1.invoices.create!(status: "in progress", created_at: "2022-04-09")
    invoice_3 = customer_1.invoices.create!(status: "in progress", created_at: "2022-04-08")
    visit "/admin"

    within("#incompleted_invoices") do
      expect(invoice_3.created_at.strftime("%A, %B %d, %Y")).to appear_before(invoice_2.created_at.strftime("%A, %B %d, %Y"))
      expect(invoice_2.created_at.strftime("%A, %B %d, %Y")).to appear_before(invoice_1.created_at.strftime("%A, %B %d, %Y"))
    end
  end

  it "has a list of the top 5 customers" do

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
    
  

    visit "/admin"

    expect(page).to have_content("Top 5 Customers")
    within ".cust-#{cust6.id}" do
      expect(page).to have_content(cust6.last_name)
      expect(page).to have_content(4)
    end
    within ".cust-#{cust7.id}" do
      expect(page).to have_content(cust7.last_name)
      expect(page).to have_content(6)
    end
    within ".cust-#{cust1.id}" do
      expect(page).to have_content(cust1.last_name)
      expect(page).to have_content(5)
    end
    within ".top-customers" do
      expect(cust7.first_name).to appear_before(cust1.first_name)
      expect(cust1.first_name).to appear_before(cust6.first_name)
      expect(cust6.first_name).to appear_before(cust2.first_name)
      expect(cust2.first_name).to appear_before(cust4.first_name)
      expect(page).not_to have_content(cust3.first_name)
      expect(page).not_to have_content(cust5.first_name)
    end
  end
end
