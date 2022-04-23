class BulkDiscount < ApplicationRecord
	belongs_to :merchant
	validates_presence_of :quantity, :discount
	validates :quantity, numericality: {only_integer: true, greater_than: 0} 
  	validates :discount, numericality: {greater_than_or_equal_to: 0.01, less_than_or_equal_to: 0.99}
end