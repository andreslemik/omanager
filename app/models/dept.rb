# app/models/dept.rb
class Dept < ActiveRecord::Base
  acts_as_paranoid
  has_many :orders
  has_many :order_items
  validates :name, uniqueness:
                     { conditions: -> { where(deleted_at: nil) } },
                   presence: true
end
