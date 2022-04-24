class BulkDiscount < ApplicationRecord
	belongs_to :merchant
	has_many :invoices, through: :merchant
	validates_presence_of :quantity, :discount
	validates :quantity, numericality: {only_integer: true, greater_than: 0} 
  	validates :discount, numericality: {greater_than_or_equal_to: 0.01, less_than_or_equal_to: 0.99}

  	def updatable?
  		pending_invoices = invoices.joins(:invoice_items)
  									.where("invoice_items.quantity >= #{quantity}")
  									.where(status: 1)
  		pending_invoice_items = pending_invoices.flat_map{|invoice| invoice.invoice_items}
  		pending_invoice_items.none?{|invoice_item| invoice_item.applied_discount == self}
  	end

  	def self.applicable?(new_params)
  		merchant = Merchant.find(new_params[:merchant_id])
  		bulk_discount = merchant.bulk_discounts.create(new_params)
  		item = merchant.items.create(name: 'item', description: 'item things', unit_price: 100)
  		customer = Customer.create(first_name: 'cust', last_name: 'omer')
  		invoice = Invoice.create(customer: customer)
  		invoice_item = InvoiceItem.create(item: item, invoice: invoice, unit_price: 100, quantity: new_params[:quantity])
  		applied = invoice_item.applied_discount == bulk_discount
  		bulk_discount.destroy
  		duplicate = pluck(:quantity).include?(new_params[:quantity]) && pluck(:discount).include?(new_params[:discount])
  		result = applied && !duplicate
  		result
  	end
end