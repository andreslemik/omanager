# OrderItem model
class OrderItem < ActiveRecord::Base
  include AASM
  has_paper_trail
  belongs_to :order, autosave: true
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
    ov = OptionValue.where(id: option_values)
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

  aasm do
    state :pending, initial: true
    state :working
    state :ready
    state :delivery
    state :done
    state :canceled

    event :work do
      after do
        self.order.work!
      end
      transitions from: :pending, to: :working
    end
    event :stop_work do
      transitions from: :working, to: :pending
    end
    event :get_ready do
      transitions from: :working, to: :ready
    end
    event :to_delivery do
      transitions from: :ready, to: :delivery
    end

  end
end
