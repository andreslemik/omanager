FactoryGirl.define do
  factory :dept do
    name { "#{Faker::Name.name} #{rand(1000000)}" }
  end
end