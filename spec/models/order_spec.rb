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

  it 'order retail' do
    order = create :order
    expect(order.retail?).to be true
  end

  it 'order not retail' do
    order = create :order, :dealer_order
    expect(order.retail?).to be false
  end
end
