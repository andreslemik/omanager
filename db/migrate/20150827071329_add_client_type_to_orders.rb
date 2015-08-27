class AddClientTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :retail_client, :boolean, default: true
  end
end
