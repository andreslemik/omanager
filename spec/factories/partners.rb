FactoryGirl.define do
  factory :partner do
    name { "#{Faker::Name.name}-#{rand(100000)}" }

    trait :supplier do
      partner_type :supplier
    end

    trait :customer do
      partner_type :customer
    end

  end
end