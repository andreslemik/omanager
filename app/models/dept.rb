class Dept < ActiveRecord::Base
  acts_as_paranoid
  has_many :orders
  validates :name, uniqueness: { conditions: -> { where(deleted_at: nil) } }, presence: true


end
