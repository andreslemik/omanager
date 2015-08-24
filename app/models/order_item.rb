class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  attr_accessor :category, :manufacturer

end
