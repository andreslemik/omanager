class AddDeptToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :dept, index: true, foreign_key: true
  end
end
