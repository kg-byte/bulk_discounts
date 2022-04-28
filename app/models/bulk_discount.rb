class BulkDiscount < ApplicationRecord
	belongs_to :merchant
	has_many :invoices, through: :merchant
	validates_presence_of :quantity, :discount
	validates :quantity, numericality: {only_integer: true, greater_than: 0} 
  	validates :discount, numericality: {greater_than_or_equal_to: 0.01, less_than_or_equal_to: 0.99}
  	validates_with DiscountValidator, :on => :update
  	validates_with DiscountValidator, :on => :create

  	def updatable?
  		pending_invoices = invoices.joins(:invoice_items)
  									.where("invoice_items.quantity >= #{quantity}")
  									.where(status: 1)
  		pending_invoice_items = pending_invoices.flat_map{|invoice| invoice.invoice_items}
  		pending_invoice_items.none?{|invoice_item| invoice_item.applied_discount == self}
  	end


  	def self.find_holiday_discount_id(holiday_discount)
  		if find_by(name: holiday_discount)
  			find_by(name: holiday_discount).id
  		else 
  			nil 
  		end
  	end
end