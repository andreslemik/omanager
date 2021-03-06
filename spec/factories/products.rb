FactoryGirl.define do
  factory :product do
    name { "#{Faker::Commerce.product_name} #{rand(100_000)}" }
    category
    association :manufacturer, factory: [:partner, :supplier, :own]
    price 10_000
    margin 25

    trait :own_supplier do
      association :manufacturer, factory: [:partner, [:supplier, :own]]
    end

    after :create do |p|
      option_type = FactoryGirl.create :product_option_type, product: p
      FactoryGirl.create_list :product_option_value, 5,
                              product: p, option_type: option_type.option_type
    end
  end
end
