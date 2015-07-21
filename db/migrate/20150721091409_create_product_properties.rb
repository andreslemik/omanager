class CreateProductProperties < ActiveRecord::Migration
  def change
    create_table :product_properties do |t|
      t.string :value
      t.references :product, index: true, foreign_key: true
      t.references :property, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
