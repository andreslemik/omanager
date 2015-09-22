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
      order_item.save!
      expect(@order.aasm_state).to eq('working')
    end
    it 'after one of two items state change back order not change' do
      order_item = nil
      (0..1).each do |i|
        order_item = @order.order_items[i]
        order_item.fabrication_date = Date.today
        order_item.save!
      end
      expect{order_item.stop_work!}.to raise_error(AASM::InvalidTransition)
    end
  end
end
