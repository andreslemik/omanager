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


  scope :long_order, -> { includes(:category).order('categories.name, products.name')  }

  validates :name, :category, presence: true
  validates :manufacturer, presence: true


  def long_name
    "#{self.category.name}: #{self.name}"
  end

  def price_mod(*mods)
    # Стоимость продукта с учётом его модификаторов цены (значения опций)
    p_price = self.price
    mods_sum = self.product_option_values.find(mods).map(&:diff).sum
    p_price + mods_sum
  end

end
