class AddDeptReferenceToOrderItems < ActiveRecord::Migration
  def change
    add_reference :order_items, :dept, index: true, foreign_key: true
  end
end
