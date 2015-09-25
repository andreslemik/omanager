class AddIndexOnOwnToPartners < ActiveRecord::Migration
  def change
    add_index :partners, :own
  end
end
