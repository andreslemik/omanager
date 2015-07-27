class AddUserToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :author_id, :integer
    add_foreign_key :orders, :users, column: :author_id
  end
end
