class CreateDepts < ActiveRecord::Migration
  def change
    create_table :depts do |t|
      t.string :name
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :depts, :deleted_at
  end
end
