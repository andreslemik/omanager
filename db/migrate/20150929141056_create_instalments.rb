class CreateInstalments < ActiveRecord::Migration
  def change
    create_table :instalments do |t|
      t.references :order, index: true, foreign_key: true
      t.date :payment_date
      t.decimal :amount, precision: 8, scale: 2
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
  end
end
