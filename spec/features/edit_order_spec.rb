require 'rails_helper'

describe 'Edit order feature' do
  before :each do
    user = FactoryGirl.create :manager
    login_as user
    @order = FactoryGirl.create :order
  end

  it 'open edit order form', js: true, driver: :selenium do
    order = Order.all.sample
    visit edit_order_path(order)
    sleep(inspection_time=5)
  end


end