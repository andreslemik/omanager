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

  has_many :order_items, dependent: :destroy, inverse_of: :order
  has_many :products, through: :order_items
  belongs_to :dept, -> { with_deleted }
  belongs_to :author, -> { with_deleted }, class_name: User
  belongs_to :partner

  has_many :operations, as: :accountable,
                        class_name: 'Account', dependent: :destroy

  validates :dept_id, presence: { message: 'Укажите офис' }, if: :retail?
  validates :order_date, presence: { message: 'Укажите дату' }, if: :retail?
  validates :dog_num, presence: { message: 'Укажите номер договора' },
                      if: :retail?
  validates :client, :phone, :address, :area, presence: true, if: :retail?
  validates :partner_id, presence: true, unless: :retail?

  validates :order_items, presence: true

  accepts_nested_attributes_for :order_items,
                                reject_if: proc { |attrs| attrs.blank? },
                                allow_destroy: true

  after_create :add_accounts

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
    retail_client
  end

  def order_type
    return 'Частный' if retail_client
    'Корп'
  end

  def total
    order_items.map(&:subtotal).sum
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
      transitions from: :working, to: :pending
    end
    event :get_ready do
      transitions from: :working, to: :ready
    end
    event :done do
      transitions from: :ready, to: :done
    end
    event :cancel do
      transitions from: [:pending, :working], to: :canceled
    end
  end

  private

  def add_accounts
    operation = operations.new
    unless retail?
      partner = Partner.find partner_id
      operation = partner.operations.new
    end
    operation.operation_date = Time.now
    operation.operation_type = :expense
    operation.amount = total
    operation.memo = "Договор №#{dog_num} от #{I18n.l(order_date)}"
    operation.save!
  end
end
