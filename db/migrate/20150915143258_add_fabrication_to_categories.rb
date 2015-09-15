class AddFabricationToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :fabrication, :boolean, default: true
  end
end
