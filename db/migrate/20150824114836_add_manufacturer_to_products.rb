class AddManufacturerToProducts < ActiveRecord::Migration
  def change
    add_column :products, :manufacturer_id, :integer, index: true

    add_index :products, :manufacturer_id
    add_foreign_key :products, :partners, column: :manufacturer_id
  end
end
