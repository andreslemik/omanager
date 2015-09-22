FactoryGirl.define do
  factory :account do
    amount { Faker::Number.number 4 }
    operation_date { Faker::Date.between 6.months.ago, Date.today }
    #TODO add other associations when they will appear
    trait :partner_operation do
      association :accountable, factory: [:partner, :customer]
    end

    trait :order_operation do
      association :accountable, factory: :retail_order
    end


    operation_type :income

    trait :expence do
      operation_type :expence
    end
  end
end