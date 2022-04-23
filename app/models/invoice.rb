class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants
  has_many :transactions, dependent: :destroy

  enum status: {"cancelled" => 0, "in progress" => 1, "completed" => 2}


  def self.not_completed
    where(invoices: {status: 1}).order(created_at: :asc)
  end
  
  def total_revenue
    invoice_items.sum("unit_price * quantity").to_f/100
  end

  def discounted_revenue
    discount = invoice_items.joins(:bulk_discounts)
                                      .where('invoice_items.quantity >= bulk_discounts.quantity')
                                      .select('invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity *(bulk_discounts.discount)/100.00) as total_discount')
                                      .group('invoice_items.id')
                                      .sum(&:total_discount)
    total_revenue - discount
  end
end
