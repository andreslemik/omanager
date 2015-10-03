require 'rails_helper'

describe 'Login user' do
  it 'sign me in' do
    pwd = '12345678'
    user = FactoryGirl.create :manager, password: pwd, password_confirmation: pwd
    visit new_user_session_path
    within '#new_user' do
      fill_in 'user_login_key', with: user.email
      fill_in 'user_password', with: pwd
    end
    click_button 'Войти'
    expect(page).to have_content 'Вход в систему выполнен'
  end
end
