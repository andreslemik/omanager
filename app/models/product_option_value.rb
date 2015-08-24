class ProductOptionValue < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :product
  belongs_to :option_value
end
