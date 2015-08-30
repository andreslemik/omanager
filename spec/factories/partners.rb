FactoryGirl.define do
  factory :partner do
    name { "#{Faker::Name.name}-#{rand(100_000)}" }
    partner_type :supplier

    trait :supplier do
      partner_type :supplier
    end

    trait :customer do
      partner_type :customer
    end

    trait :own do
      own true
    end

  end
end
