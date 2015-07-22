ActiveAdmin.register Order do

  permit_params :date, :memo,
                order_items_attributes: [:order_id, :product_id, :amount, :cloth_category, :cloth, :cost]

  filter :products
  filter :order_date
  filter :memo
  filter :aasm_state, as: :select
end
