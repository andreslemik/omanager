FactoryGirl.define do
  factory :operation, class: 'Account' do
    operation_date { Faker::Date.between 7.days.ago, Date.today }
    memo { Faker::Lorem.paragraph }
  end
end