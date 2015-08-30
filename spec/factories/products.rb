FactoryGirl.define do
  factory :product do
    name { Faker::Commerce.product_name }
    category
    association :manufacturer, factory: [:partner, :supplier]
    price 10000
    margin 25

    trait :own_supplier do
      association :manufacturer, factory: [:partner, [:supplier, :own]]
    end
  end
end
