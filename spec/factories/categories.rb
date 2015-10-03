FactoryGirl.define do
  factory :category do
    name { "#{Faker::Name.name} #{rand 1000000}" }
  end
end