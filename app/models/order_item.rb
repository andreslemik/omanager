class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  attr_accessor :category, :manufacturer
  serialize :option_values, JSON

  validates :product_id, :amount, :cost, presence: true

  def option_values=(val)
    self[:option_values] = val.map(&:to_i)
  end

  def subtotal
    amount.to_i * cost.to_f
  end
end
