# app/models/property.rb
class Property < ActiveRecord::Base
  has_many :product_properties, dependent: :delete_all, inverse_of: :property
  has_many :products, through: :product_properties

  validates :name, presence: true

  scope :sorted, -> { order(:name) }

  after_touch :touch_all_products

  private

  def touch_all_products
    products.update_all(updated_at: Time.current)
  end
end
