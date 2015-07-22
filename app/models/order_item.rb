class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  enum cloth_category: [:c250, :c300, :c350, :c400, :c450, :c500]
end
