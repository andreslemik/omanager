# Order model class
class Order < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail
  has_many :order_items
  has_many :products, through: :order_items
  belongs_to :dept, -> { with_deleted }
  belongs_to :author, -> { with_deleted }, class_name: User

  validates :dept_id, presence: { message: 'Укажите офис' }
  validates :order_date, presence: { message: 'Укажите дату' }
  validates :dog_num, presence: { message: 'Укажите номер договора' }

  accepts_nested_attributes_for :order_items, reject_if: proc { |attrs| attrs.blank? }

  def author
    User.unscoped { super }
  end

  def dept
    Dept.unscoped { super }
  end
end
