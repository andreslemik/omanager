FactoryGirl.define do
  factory :option_type do
    name { "#{Faker::Lorem.word} #{rand(1_000_000)}" }
    after :create do |ot|
      create_list :option_value, 5, option_type: ot
    end
  end
end
