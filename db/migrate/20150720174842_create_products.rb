class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :image
      t.decimal :base_price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
