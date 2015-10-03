FactoryGirl.define do
  factory :product_option_value do
    product
    option_value
    diff { (Faker::Number.between 500, 2500).round(-2) }
  end
end
