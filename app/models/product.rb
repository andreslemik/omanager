# app/models/product.rb
class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_paranoid

  belongs_to :category
  belongs_to :manufacturer, class_name: 'Partner'
  has_many :product_option_types, dependent: :destroy, inverse_of: :product
  has_many :product_option_values, dependent: :destroy
  has_many :option_types, through: :product_option_types
  has_many :product_properties, dependent: :destroy, inverse_of: :product

  accepts_nested_attributes_for :product_properties,
                                allow_destroy: true,
                                reject_if: ->(pp) { pp[:property_id].blank? || pp[:value].blank? }
  accepts_nested_attributes_for :product_option_types, allow_destroy: true
  accepts_nested_attributes_for :product_option_values, allow_destroy: true

  scope :long_order, lambda {
    includes(:category)
      .order('categories.name, products.name')
  }

  validates :name, :category, presence: true
  validates :manufacturer, presence: true

  def long_name
    "#{category.name}: #{name} (#{manufacturer.name})"
  end

  def price
    super.nil? ? 0 : super
  end

  def price_mod(retail, *mods)
    # Cost of the product considering its price modifiers (option_values)
    rt = retail.to_i
    return price if rt == 0 && !mods.any?
    result = product_option_values.where(option_value_id: mods.flatten)
             .map(&:diff).sum + price
    return result unless rt == 1
    result *= (1 + margin.to_i / 100.0)
    result.round(-2)
  end

  ransacker :fullname do
    Arel.sql('products.name||categories.name')
  end
end
