require 'rails_helper'

describe 'New order feature', type: :feature do
  before :each do
    user = FactoryGirl.create :manager
    login_as user
  end
  it 'open new order form', js: true do
    visit new_order_path
    within('#new_order') do
      choose 'order_order_type_dealer'
    end
    expect(page).to have_selector('.corporate', visible: true)
  end
end
