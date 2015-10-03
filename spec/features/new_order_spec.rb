require 'rails_helper'

describe 'New order feature', type: :feature do
  before(:each) do
    user = create :user, password: '12345678', password_confirmation: '12345678'
    visit new_user_session_path
    within('#new_user') do
      fill_in 'user_login_key', with: user.username
      fill_in 'user_password', with: '12345678'
    end
    click_button 'Войти'
  end

  it 'open new order form', js: true do
    visit new_order_path
    within('#new_order') do
      choose 'order_order_type_dealer'
    end
    expect(page).to have_selector('.corporate', visible: true)
  end
end
