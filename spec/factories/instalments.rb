FactoryGirl.define do
  factory :instalment do
    order
    payment_date { Faker::Date.between Date.today, 6.months.from_now }
    amount { Faker::Number.number 4 }
  end
end