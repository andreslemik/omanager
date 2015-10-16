class AddDeliveryMemoToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :delivery_memo, :text
  end
end
