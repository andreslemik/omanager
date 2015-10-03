require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
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
      roles = [:admin, :manager, :fabrication]
      roles.each do |role|
        before do
          login_as role
        end
        it 'return http succes' do
          get :index
          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe 'GET #internals' do
    before { login_as :manager }
    it 'return http succes' do
      get :internals
      expect(response).to have_http_status(:success)
    end
  end
  describe 'GET #show' do
    before { login_as :manager }
    it 'assigns the requested order to @order' do
      order = FactoryGirl.create :order
      get :show, id: order
      expect(assigns(:order)).to eq(order)
    end
  end
  describe 'GET #new' do
    before { login_as :manager }
    it 'assigns a new Order to @order' do
      get :new
      expect(assigns(:order)).to be_a_new(Order)
    end
  end
  describe 'GET #edit' do
    before { login_as :manager }
    it 'find specific item' do
      order = FactoryGirl.create :order
      get :edit, id: order
      expect(assigns(:order)).to eq(order)
    end
  end
  describe 'POST #update' do
    let(:order) { FactoryGirl.create :order, order_type: :retail, dog_num: '555' }
    before { login_as :manager }
    it 'update order with valid attributes' do
      post :update, id: order, order: { dog_num: '556' }
      order.reload
      expect(order.dog_num).to eq('556')
    end
    it 'update order with invalid attributes' do
      post :update, id: order, order: { order_items: [] }
      expect(response).to redirect_to(order)
    end
  end
  describe 'DELETE #destroy' do
    before do
      login_as :manager
      @order = FactoryGirl.create :order
    end
    it 'delete the order' do
      expect{
        delete :destroy, id: @order
      }.to change(Order, :count).by(-1)
    end
  end
end
