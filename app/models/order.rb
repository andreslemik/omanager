# Order model class
class Order < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

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

  validates :dept_id, presence: { message: 'Укажите офис' }, if: :reatil?
  validates :order_date, presence: { message: 'Укажите дату' }, if: :reatil?
  validates :dog_num, presence: { message: 'Укажите номер договора' }, if: :reatil?
  validates :client, :phone, :address, :area, presence: true, if: :reatil?

  validates :order_items, presence: true

  accepts_nested_attributes_for :order_items,
                                reject_if: proc { |attrs| attrs.blank? }

  def author
    User.unscoped { super }
  end

  def dept
    Dept.unscoped { super }
  end

  def retail?

  end

end
