class AddAasMtoOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :aasm_state, :string
    add_index :order_items, :aasm_state
  end
end
