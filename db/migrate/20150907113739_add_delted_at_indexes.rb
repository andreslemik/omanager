class AddDeltedAtIndexes < ActiveRecord::Migration
  def change
    add_index :orders, :deleted_at
  end
end
