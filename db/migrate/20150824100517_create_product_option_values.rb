class CreateProductOptionValues < ActiveRecord::Migration
  def change
    create_table :product_option_values do |t|
      t.references :product, index: true, foreign_key: true
      t.references :option_value, index: true, foreign_key: true
      t.decimal :diff, precision: 8, scale: 2
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
