class AddDeliveryDateToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :delivery_date, :date
    add_index :order_items, :delivery_date
  end
end
