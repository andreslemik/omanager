class AddCostsToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :delivery_cost, :decimal, precision: 8, scale: 2
    add_column :order_items, :lift_cost, :decimal, precision: 8, scale: 2
    add_column :order_items, :install_cost, :decimal, precision: 8, scale: 2
  end
end
