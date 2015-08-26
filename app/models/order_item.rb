class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  attr_accessor :category, :manufacturer
  serialize :option_values, JSON


  def option_values=(val)
    self[:option_values] = val.map(&:to_i)
  end


end
