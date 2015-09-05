class AddAasmIndexToOrders < ActiveRecord::Migration
  def change
    add_index :orders, :aasm_state
  end
end
