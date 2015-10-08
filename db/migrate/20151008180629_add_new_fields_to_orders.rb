class AddNewFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_cost, :decimal,  precision: 8, scale: 2
    add_column :orders, :lift_cost, :decimal,  precision: 8, scale: 2
    add_column :orders, :install_cost, :decimal,  precision: 8, scale: 2
  end
end
