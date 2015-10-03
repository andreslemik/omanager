FactoryGirl.define do
  factory :order_item do
    order
    product
    amount { Faker::Number.between 1, 5 }
    cost { Faker::Commerce.price }
  end
end
