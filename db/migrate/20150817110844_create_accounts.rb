class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.date :operation_date, null: false, index: true
      t.integer :operation_type, null: false, index: true
      t.decimal :amount, precision: 8, scale: 2
      t.datetime :deleted_at, index: true
      t.references :accountable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
