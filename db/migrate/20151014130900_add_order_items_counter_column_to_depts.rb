class AddOrderItemsCounterColumnToDepts < ActiveRecord::Migration
  def change
    add_column :depts, :order_items_count, :integer, default: 0
    Dept.find_each { |dept| Dept.reset_counters(dept.id, :order_items)}
  end
end
