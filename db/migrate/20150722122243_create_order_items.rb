class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :amount
      t.string :cloth_category
      t.string :cloth
      t.decimal :cost, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
