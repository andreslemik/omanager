class Partner < ActiveRecord::Base
  acts_as_paranoid

  validates :name, uniqueness: { conditions: -> { where(deleted_at: nil) } }, presence: true

  has_many :operations, as: :accountable, class_name: 'Account'
end
