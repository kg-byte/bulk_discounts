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
end