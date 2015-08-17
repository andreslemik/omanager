class AddIndexToPartners < ActiveRecord::Migration
  def change
    add_index :partners, :deleted_at
  end
end
