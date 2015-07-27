class Order < ActiveRecord::Base
  acts_as_paranoid
  has_many :order_items
  has_many :products, through: :order_items
end
