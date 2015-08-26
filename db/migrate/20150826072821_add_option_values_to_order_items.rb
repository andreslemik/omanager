class AddOptionValuesToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :option_values, :string
  end
end
