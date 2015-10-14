# app/models/product_property.rb
class ProductProperty < ActiveRecord::Base
  acts_as_list scope: :product

  belongs_to :product, touch: true, inverse_of: :product_properties
  belongs_to :property, inverse_of: :product_properties

  validates :property, presence: true

  default_scope { order("#{table_name}.position") }
end
