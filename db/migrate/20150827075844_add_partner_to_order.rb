class AddPartnerToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :partner, index: true, foreign_key: true
  end
end
