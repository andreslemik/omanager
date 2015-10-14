# app/models/order.rb
class Order < ActiveRecord::Base
  include Authority::Abilities
  include StateMachines::OrderStateMachine
  acts_as_paranoid
  has_paper_trail

  paginates_per 10

  self.authorizer_name = 'OrderAuthorizer'

  enum area: {  'Новый город': 11, 'Верхняя терраса': 12, 'Нижняя терраса': 13,
                'Центр': 21, 'Север': 22,
                'Ближнее засвияжье': 31, 'Дальнее засвияжье': 32,
                'Железнодорожный р-н': 4,
                'Не Ульяновск': 0
       }
  enum order_type: { retail: 0, dealer: 1, internal: 2 }

  has_many :order_items, dependent: :destroy, inverse_of: :order, autosave: true
  has_many :products, through: :order_items
  has_many :categories, through: :products
  belongs_to :dept, -> { with_deleted }
  belongs_to :author, -> { with_deleted }, class_name: User
  belongs_to :partner

  has_many :operations, as: :accountable,
                        class_name: 'Account', dependent: :destroy

  has_many :instalments, dependent: :destroy

  validates :dept_id, presence: { message: 'Укажите офис' }, if: :retail?
  validates :order_date, presence: { message: 'Укажите дату' }, if: :retail?
  validates :dog_num, presence: { message: 'Укажите номер договора' },
                      if: :retail?
  validates :client, :phone, :address, :area, presence: true, if: :retail?
  validates :partner_id, presence: true, if: :dealer?
  validates :order_items, presence: true
  validates :order_type, presence: { message: 'Не указан тип договора' }

  accepts_nested_attributes_for :order_items,
                                reject_if: proc { |attrs| attrs.blank? },
                                allow_destroy: true

  after_save :update_accounts
  after_destroy :delete_accounts
  before_save :clear_attributes

  scope :without_internals, lambda {
    where.not(order_type: \
    Order.order_types[:internal])
  }

  scope :internals, -> { where(order_type: Order.order_types[:internal]) }

  # scopes by order state
  Order.aasm.states.map(&:name).each do |s|
    scope s, -> { where aasm_state: s }
  end

  def author
    User.unscoped { super }
  end

  def dept
    Dept.unscoped { super }
  end

  # define methods by order_types (retail?, dealer?, internal?)
  Order.order_types.keys.each do |key|
    define_method("#{key}?".to_sym) do
      return true if order_type == key.to_s || @order_type == key.to_s
      false
    end
  end

  def total
    order_items.map(&:subtotal).sum
  end

  def instalments_total
    instalments.summary
  end

  def income_total
    operations.income.summary
  end

  # define methods to determine if all fabrication order_items have some state
  OrderItem.aasm.states.each do |state|
    define_method "all_items_#{state.name}?".to_sym do
      order_items.to_fabrication
        .pluck(:aasm_state).all? { |s| s == state.name.to_s }
    end
  end

  def accounting_done?
    false
  end

  # fix error: '1' is not a valid order_type
  def order_type=(value)
    if value.is_a?(String) && value.to_i.to_s == value
      super value.to_i
    else
      super value
    end
  end

  def area=(value)
    if value.is_a?(String) && value.to_i.to_s == value
      super value.to_i
    else
      super value
    end
  end

  def balance_at(date)
    return 0 unless :retail?
    operations_balance = operations.expense.summary - operations.income.summary
    if instalments.any?
      inst_after = instalments.after_date(date).summary
      operations_balance - inst_after
    else
      operations_balance
    end
  end

  ransacker :registered do |_parent|
    Arel.sql('date(order_date)')
  end

  private

  def update_accounts
    if dealer?
      operation = Partner.find(partner_id)
                  .operations.find_or_initialize_by(order_id: id)
    else
      operation = operations.find_or_initialize_by(order_id: id)
    end
    attrs = { amount: total, memo: decorate.to_s }
    attrs.merge!(operation_date: Time.now,
                 operation_type: :expense, amount: total,
                 memo: decorate.to_s,
                 order_id: id) if operation.new_record?
    operation.attributes = attrs
    operation.save!
  end

  def delete_accounts
    Account.destroy_all(order_id: id)
  end

  def clear_attributes
    self.partner_id = nil if retail? || internal?
    self.client = self.address = self.phone = self.area = nil \
      if internal? || dealer?
  end
end
