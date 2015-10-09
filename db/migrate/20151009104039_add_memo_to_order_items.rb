class AddMemoToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :memo, :text
  end
end
