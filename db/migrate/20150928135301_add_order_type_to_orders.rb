class AddOrderTypeToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :order_type, :integer
    add_index :orders, :order_type

    Order.find_each do |order|
      case order.retail_client
        when true
          type = Order.order_types[:retail]
        when false
          type = Order.order_types[:dealer]
        else
          type = -1
      end
      order.update_attribute(:order_type, type)
    end
  end

  def down
    remove_index :orders, :order_type
    remove_column :orders, :order_type
  end
end
