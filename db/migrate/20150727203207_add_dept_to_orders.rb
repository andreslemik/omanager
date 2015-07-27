class AddDeptToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :dept, index: true, foreign_key: true
  end
end
