class AddOwnToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :own, :boolean, default: false
  end
end
