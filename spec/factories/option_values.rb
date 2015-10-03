FactoryGirl.define do
  factory :option_value do
    option_type
    name { "#{Faker::Lorem.word} #{rand 1_000_000}" }
  end
end
