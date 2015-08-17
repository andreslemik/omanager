class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.text :memo
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
