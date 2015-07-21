class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_paranoid

  belongs_to :category
  has_many :product_properties, dependent: :destroy, inverse_of: :product
  accepts_nested_attributes_for :product_properties,
                                allow_destroy: true,
                                reject_if: ->(pp) { pp[:property_id].blank? || pp[:value].blank? }

  validates :name, uniqueness: { conditions: -> { where(deleted_at: nil) } }, presence: true
end
