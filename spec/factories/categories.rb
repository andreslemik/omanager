FactoryGirl.define do
  factory :category do
    name { "#{Faker::Lorem.word} #{rand 1_000_000}" }
    fabrication true
  end
end
