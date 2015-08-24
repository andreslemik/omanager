class ChangeOrderItems < ActiveRecord::Migration
  def change
    remove_columns :order_items, :cloth_category, :cloth
  end
end
