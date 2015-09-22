require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  # def login_as(role)
  #   @request.env['devise.mapping'] = Devise.mappings[:user]
  #   user = FactoryGirl.create role
  #   sign_in user
  # end
  before :each do
    @order = FactoryGirl.create :retail_order
  end
  describe 'GET #new' do
    login_as :admin
    it 'returns http success' do
      get :new, { order_id: @order.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    login_as :admin
    it 'returns http success' do
      get :edit, { id: @order.order_items.first }
      expect(response).to have_http_status(:success)
    end
  end

end
