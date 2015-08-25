class ProductOptionValue < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :product
  belongs_to :option_value
  has_one :option_type, through: :option_value
end
