class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_paranoid

  validates :name, uniqueness: { conditions: -> { where(deleted_at: nil) } }, presence: true
end
