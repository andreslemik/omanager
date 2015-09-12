class AddAasMtoOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :aasm_state, :string
    add_index :order_items, :aasm_state

    execute <<-SQL
      UPDATE order_items SET aasm_state = 'pending';
    SQL
  end
end
