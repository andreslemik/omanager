FactoryGirl.define do
  factory :operation, class: 'Account' do
    operation_date { Faker::Date.between 7.days.ago, Date.today }
    memo { Faker::Lorem.paragraph }
    operation_type :expense
    amount { Faker::Number.between 1000, 1000000 }
  end
end