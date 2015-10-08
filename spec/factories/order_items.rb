FactoryGirl.define do
  factory :order_item do
    order
    product
    amount { Faker::Number.between 1, 5 }
    cost { Faker::Commerce.price }
    descr_basis 'Цвет основа'
    descr_assort 'Цвет подбор'
    special_notes 'Специальные отметки'
  end
end
