class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date :order_date
      t.text :memo
      t.string :aasm_state

      t.timestamps null: false
    end
  end
end
