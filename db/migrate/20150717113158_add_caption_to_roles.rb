class AddCaptionToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :caption, :string
  end
end
