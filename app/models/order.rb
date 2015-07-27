class Order < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail
  has_many :order_items
  has_many :products, through: :order_items
  belongs_to :dept
  belongs_to :author, class_name: User

  validates :dept_id, presence: true
end
