FactoryGirl.define do
  factory :dept do
    name { "#{Faker::Name.name} #{rand(1_000_000)}" }
  end
end
