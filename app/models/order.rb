# Order model class
class Order < ActiveRecord::Base
  include Authority::Abilities
  include AASM
  acts_as_paranoid
  has_paper_trail

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

  def retail?
    return true if order_type == 'retail'
    false
  end

  def dealer?
    return true if order_type == 'dealer'
    false
  end

  def order_type_s
    # short order_type
    case order_type
    when 'retail'
      return 'ЧЗ'
    when 'dealer'
      return "ДЗ: #{partner.name}"
    when 'internal'
      return 'ВН'
    end
  end

  def dog_num_s
    return dog_num unless dog_num.blank?
    'б/н'
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

  def partner_name
    return 'Внутренний заказ' if order_type == 'internal'
    partner.name
  end

  def all_items_pending?
    order_items.to_fabrication.pluck(:aasm_state).all? { |s| s == 'pending' }
  end

  def all_items_ready?
    order_items.to_fabrication.pluck(:aasm_state).all? { |s| s == 'ready' }
  end

  def all_items_done?
    order_items.to_fabrication.pluck(:aasm_state).all? { |s| s == 'done' }
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

  def balance_on(date)
    return 0 if (total - income_total) == 0 || !retail?
    operations_balance = operations.expense.summary - operations.income.summary
    return operations_balance unless instalments.any?
    inst_after = instalments.after_date(date).summary
    operations_balance - inst_after
  end

  ransacker :registered do |_parent|
    Arel.sql('date(order_date)')
  end

  ############ AASM ################
  aasm do
    state :pending, inital: true
    state :working
    state :ready
    state :done
    state :canceled

    event :work do
      transitions from: :pending, to: :working
    end
    event :stop_work do
      transitions from: :working, to: :pending, guard: :all_items_pending?
    end
    event :get_ready do
      transitions from: :working, to: :ready, guard: :all_items_ready?
    end
    event :done do
      transitions from: :ready, to: :done, guard: [:all_items_done?, :accounting_done?]
    end
    event :cancel do
      transitions from: [:pending, :working], to: :canceled
    end
  end

  private

  def update_accounts
    operation = operations.find_or_initialize_by(order_id: id)
    operation = Partner.find(partner_id)
                .operations.find_or_initialize_by(order_id: id) if dealer?
    operation.attributes = { amount: total, memo: decorate.to_s }
    operation.attributes = { operation_date: Time.now,
                             operation_type: :expense, amount: total,
                             memo: decorate.to_s,
                             order_id: id
    } if operation.new_record?
    operation.save!
  end

  def delete_accounts
    Account.destroy_all(order_id: id)
  end
end
