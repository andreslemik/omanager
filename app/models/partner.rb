class Partner < ActiveRecord::Base
  acts_as_paranoid

  validates :name, uniqueness: { conditions: -> { where(deleted_at: nil) } }, presence: true


end
