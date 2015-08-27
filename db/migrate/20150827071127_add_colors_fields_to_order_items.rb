class AddColorsFieldsToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :descr_basis, :text
    add_column :order_items, :descr_assort, :text
    add_column :order_items, :special_notes, :text
  end
end
