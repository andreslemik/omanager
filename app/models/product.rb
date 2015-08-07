class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_paranoid

  belongs_to :category

  has_many :product_option_types, dependent: :destroy, inverse_of: :product
  has_many :option_types, through: :product_option_types
  has_many :product_properties, dependent: :destroy, inverse_of: :product
  accepts_nested_attributes_for :product_properties,
                                allow_destroy: true,
                                reject_if: ->(pp) { pp[:property_id].blank? || pp[:value].blank? }
  accepts_nested_attributes_for :product_option_types, allow_destroy: true

  validates :name, uniqueness: { conditions: -> { where(deleted_at: nil) } }, presence: true


  def long_name
    "#{self.category.name}: #{self.name}"
  end

end
