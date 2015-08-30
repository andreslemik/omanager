FactoryGirl.define do
  factory :dept do
    name { Faker::Name.name }
  end
end