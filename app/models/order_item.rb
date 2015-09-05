# OrderItem model
class OrderItem < ActiveRecord::Base
  has_paper_trail
  belongs_to :order
  belongs_to :product

  attr_accessor :category, :manufacturer
  serialize :option_values, JSON

  validates :product_id, :amount, :cost, presence: true

  def option_values=(val)
    self[:option_values] = val.map(&:to_i)
  end

  def additional
    "#{descr_basis} / #{descr_assort} / #{special_notes}"
  end

  def product_options
    return '' if option_values.blank?
    result = ''
    ov = OptionValue.find(option_values)
    ov.each do |v|
      result << v.option_type.name << ': ' << v.name
      result << ', ' unless v == ov.last
    end
    result
  end

  def retail
    return 1 if self.order.retail_client
    0
  end

  def subtotal
    amount.to_i * cost.to_f
  end
end
