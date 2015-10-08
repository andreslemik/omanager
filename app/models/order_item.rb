# OrderItem model
class OrderItem < ActiveRecord::Base
  include ActiveModel::Dirty
  include AASM
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

  after_save :update_order
  after_save :change_state, if: :fabrication_date_changed?
  after_save :delivery_state, if: :delivery_date_changed?

  def option_values=(val)
    self[:option_values] = val.map(&:to_i)
  end

  def retail
    return 1 if order.retail?
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

    event :work do
      after do
        order.work! if order.aasm_state == 'pending'
      end
      transitions from: :pending, to: :working
    end
    event :stop_work do
      after_commit do
        update_attribute(:fabrication_date, nil)
        order.stop_work! if order.all_items_pending?
      end
      transitions from: :working, to: :pending
    end
    event :get_ready do
      transitions from: [:working, :pending], to: :ready
      after_commit do
        order.get_ready! if order.all_items_ready?
      end
    end
    event :to_delivery do
      transitions from: :ready, to: :delivery
    end
    event :undo_delivery do
      after_commit do
        update_attribute(:delivery_date, nil)
      end
      transitions from: :delivery, to: :ready
    end
    event :well_done do
      transitions from: :delivery, to: :done
      after_commit do
        order.done! if order.aasm_state == 'ready'
      end
    end
  end

  ransacker :additionals do |_parent|
    Arel.sql('descr_basis||descr_assort||special_notes')
  end

  private

  def update_order
    order.update_attribute(:updated_at, Time.now)
  end

  def change_state
    return if fabrication_date.blank?
    self.work! if aasm_state == 'pending'
  end

  def delivery_state
    return if delivery_date.blank?
    self.to_delivery! if aasm_state == 'ready'
  end
end
