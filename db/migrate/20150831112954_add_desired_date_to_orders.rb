class AddDesiredDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :desired_date, :date
  end
end
