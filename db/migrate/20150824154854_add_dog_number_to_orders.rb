class AddDogNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :dog_num, :string
  end
end
