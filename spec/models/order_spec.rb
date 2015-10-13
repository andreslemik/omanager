require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'create one order' do
    expect do
      create :order
    end.to change(Order, :count).by 1
  end

  it 'order created with 3 order_items' do
    expect do
      create :order
    end.to change(OrderItem, :count).by 3
  end

  it 'order retail' do
    order = create :order
    expect(order.retail?).to be true
  end

  it 'order not retail' do
    order = create :order, :dealer_order
    expect(order.retail?).to be false
  end

  it 'change order from retail to internal clear some attrs' do
    order = create :order
    order.update_attribute(:order_type, :internal)
    expect(order.partner_id).to be nil
    expect(order.client).to be nil
    expect(order.address).to be nil
    expect(order.phone).to be nil
  end
  it 'change order from dealer to internal clear some attrs' do
    order = create :order, :dealer_order
    order.update_attribute(:order_type, :internal)
    expect(order.partner_id).to be nil
  end
end
