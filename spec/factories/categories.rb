FactoryGirl.define do
  factory :category do
    name { "#{Faker::Name.name} #{rand 1_000_000}" }
    fabrication true
  end
end
