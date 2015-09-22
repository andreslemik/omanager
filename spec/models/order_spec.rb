require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'create one order' do
    expect {
      create :order
    }.to change(Order, :count).by 1
  end

  it 'order created with 3 order_items' do
    expect {
      create :order
    }.to change(OrderItem, :count).by 3
  end
end
