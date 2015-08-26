class ProductOptionType < ActiveRecord::Base
  acts_as_list scope: :product

  belongs_to :product, inverse_of: :product_option_types
  belongs_to :option_type, inverse_of: :product_option_types
  has_many :option_values, through: :option_type
end
