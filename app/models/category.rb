class Category < ActiveRecord::Base
  acts_as_paranoid

  validates :name, uniqueness: { conditions: -> { where(deleted_at: nil) } }, presence: true

  has_many :products

  default_scope { order :name }
end
