class Customer < ApplicationRecord


  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  validates_presence_of :first_name, :last_name

 def self.top_5_customers
   joins(:transactions)
   .where(transactions: {result: 0})
   .where(invoices: {status: 2})
   .select("customers.*, count(transactions) as num_of_transactions")
   .group(:id)
   .order(num_of_transactions: :desc)
   .limit(5)
 end

end
