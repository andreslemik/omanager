class AddOrderIdToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :order, index: true, foreign_key: true
  end
end
