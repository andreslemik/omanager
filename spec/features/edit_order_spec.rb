require 'rails_helper'

describe 'Edit order feature' do
  before :each do
    user = FactoryGirl.create :manager
    login_as user
    @order = FactoryGirl.create :order
  end

  it 'delete one order item', js: true, driver: :selenium do
    visit edit_order_path(@order)
    first('.delete_order_item').click
    click_button('Сохранить')
    expect(@order.order_items.count).to eq(2)
  end
end
