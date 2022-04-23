class CreateBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :quantity
      t.decimal :discount
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
