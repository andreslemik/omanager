class RemoveColumnsFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :delivery_cost
    remove_column :orders, :lift_cost
    remove_column :orders, :install_cost
  end
end
