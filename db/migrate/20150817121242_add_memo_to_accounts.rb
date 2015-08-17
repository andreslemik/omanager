class AddMemoToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :memo, :text
  end
end
