class AddPartnerTypeToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :partner_type, :integer
    add_index :partners, :partner_type
  end
end
