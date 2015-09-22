FactoryGirl.define do
  factory :order do
    order_date { Faker::Date.between 7.days.ago, Date.today }
    memo { Faker::Lorem.paragraph }
    aasm_state :pending
    dept
    author
    dog_num { Faker::Number.between 1, 100000 }
    client { Faker::Name.name }
    address { Faker::Address.street_address }
    phone { Faker::PhoneNumber.cell_phone }
    area 13

    factory :retail_order do
      retail_client true
    end

    factory :dealer_order do
      retail_client false
      partner
    end

    after :build do |order|
      3.times do
        order.order_items << build(:order_item, order: order)
      end
    end

  end
end