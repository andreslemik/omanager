FactoryGirl.define do
  factory :option_value do
    option_type
    name { "#{Faker::Lorem.word} #{rand 1000000}" }
  end
end