class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :categories, :deleted_at
  end
end
