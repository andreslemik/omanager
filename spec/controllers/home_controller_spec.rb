require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  def login_as(role)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = FactoryGirl.create role
    sign_in user
  end

  describe 'GET #index' do
    context 'as unsigned user' do
      it 'returns redircet to login' do
        get :index
        expect(response.code).to eq('302')
      end
    end

    context 'as signed user with any role' do
      before :each do
        role = [:admin, :manager, :factories].sample
        login_as role
      end
      it 'return http succes' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

  end

end
