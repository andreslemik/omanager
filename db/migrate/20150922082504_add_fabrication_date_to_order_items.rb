class AddFabricationDateToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :fabrication_date, :date
    add_index :order_items, :fabrication_date
  end
end
