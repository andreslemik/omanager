class CreateOptionValues < ActiveRecord::Migration
  def change
    create_table :option_values do |t|
      t.string :name
      t.references :option_type, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
