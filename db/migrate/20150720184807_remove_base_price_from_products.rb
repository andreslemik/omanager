class RemoveBasePriceFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :base_price
  end
end
