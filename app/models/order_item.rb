# app/models/order_item.rb
class OrderItem < ActiveRecord::Base
  include ActiveModel::Dirty
  include StateMachines::OrderItemStateMachine
  include Summary
  acts_as_paranoid
  has_paper_trail
  belongs_to :order
  belongs_to :product
  belongs_to :dept
  has_one :category, through: :product
  has_one :partner, through: :product,
                    foreign_key: :manufacturer_id, source: :manufacturer

  attr_accessor :category, :manufacturer
  serialize :option_values, JSON

  validates :product_id, :amount, :cost, presence: true

  scope :by_desired_date, lambda {
    joins(:order)
      .order('orders.desired_date asc NULLS last,
        orders.created_at desc, orders.id')
  }

  scope :to_fabrication, lambda {
    joins(:category)
      .where('categories.fabrication = ?', true)
  }
  scope :own_supplier, lambda {
    joins(:partner)
      .where('partners.own = ?', true)
      .where('partners.partner_type = ?', 0)
  }

  scope :to_order, lambda {
    joins(:partner, :category)
      .where('partners.own = ?', false)
      .where('categories.fabrication = ?', true)
      .where(aasm_state: :pending)
  }

  attr_accessor :done_check

  after_save :change_state, if: :fabrication_date_changed?
  after_save :delivery_state, if: :delivery_date_changed?
  after_save :delivery_done, if: :done_checked?

  def option_values=(val)
    self[:option_values] = val.map(&:to_i)
  end

  def retail
    return 1 if order.retail?
    0
  end

  def done_checked?
    return true if @done_check == '1'
    false
  end

  def subtotal
    amount.to_i * cost.to_f
  end

  def dept_changes
    if versions.any?
      versions.pluck(:object_changes, :id)
        .map { |a, b| [a.nil? ? '' : YAML.load(a), b] }
        .select { |a, _b| a.include? 'dept_id' }
        .sort { |a, b| b[1] <=> a[1] }
    else
      []
    end
  end

  ransacker :additionals do |_parent|
    Arel.sql('descr_basis||descr_assort||special_notes')
  end

  private

  def change_state
    return if fabrication_date.blank?
    self.work! if aasm.current_state == :pending
  end

  def delivery_state
    return if delivery_date.blank?
    self.to_delivery! if aasm.current_state == :ready
  end

  def delivery_done
    self.well_done!
  end
end
