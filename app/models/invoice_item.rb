class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :bulk_discounts, through: :item
  has_many :merchants, through: :item

  validates_presence_of :quantity, :unit_price, :status
  validates :quantity, numericality: true
  validates :quantity, numericality: {only_integer: true, greater_than: 0}
  validates :unit_price, numericality: true
  validates :unit_price, numericality: {only_integer: true, greater_than: 0}

  enum status: {"packaged" => 0, "pending" => 1, "shipped" => 2}

  def applied_discount
     bulk_discounts.where("#{quantity} >= bulk_discounts.quantity")
    .order(discount: :desc)
    .first
  end
end

