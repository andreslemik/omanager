class AddClientInfoToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :client, :string
    add_column :orders, :address, :string
    add_column :orders, :phone, :string
  end
end
