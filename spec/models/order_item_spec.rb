require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  context 'one order_item state changes' do
    before do
      @order_item = FactoryGirl.create :order_item
      @order_item.fabrication_date = Date.today
      @order_item.save!
    end
    it 'change fabrication_date leads to order_item state change' do
      expect(@order_item.aasm_state).to eq('working')
    end
    it 'change fabrication_date leads to order change state to working' do
      expect(@order_item.order.aasm_state).to eq('working')
    end
    it 'change order_item state to pending will change order state to pending' do
      @order_item.stop_work!
      expect(@order_item.order.aasm_state).to eq('pending')
    end
  end

  context 'three order_items states change' do
    before do
      @order = FactoryGirl.create :order
    end
    it 'one item change state to working change order state too' do
      order_item = @order.order_items.first
      order_item.fabrication_date = Date.today
      order_item.save
      expect(@order.aasm_state).to eq('working')
    end

    it 'all items are ready' do
      @order.order_items.each { |o| o.fabrication_date = Date.today; o.save!; o.get_ready! }
      expect(@order.aasm_state).to eq('ready')
    end

    it '2 of 3 order items are ready' do
      (1..2).each do |i|
        o = @order.order_items[i]
        o.fabrication_date = Date.today
        o.save
        o.get_ready
      end
      expect(@order.aasm_state).to eq('working')
    end

    it 'order_retail' do
      expect(@order.order_items.first.retail).to eq(1)
    end

    it 'when change delivery_date item get state "delivery"' do
      item = @order.order_items.first
      item.get_ready!
      item.update_attribute :delivery_date, Date.today
      expect(item.aasm_state).to eq('delivery')
    end

    it 'undo_delivery' do
      item = @order.order_items.first
      item.get_ready!
      item.update_attribute :delivery_date, Date.today
      item.undo_delivery!
      expect(item.delivery_date).to be_nil
    end
  end
end
