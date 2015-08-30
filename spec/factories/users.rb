FactoryGirl.define do
  Faker::Config.locale = :en
  factory :user do
    email { Faker::Internet.email }
    pwd = Faker::Internet.password(8)
    username { Faker::Internet.user_name }
    password pwd
    password_confirmation pwd
    
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    factory :admin do
      after(:create) {|user| user.add_role :admin }
    end
    factory :manager do
      after(:create) {|user| user.add_role :manager }
    end
    factory :fabrication do
      after(:create) {|user| user.add_role :fabrication }
    end
  end
end