require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  before :each do
    @order = FactoryGirl.create :order
  end

  describe 'GET #index' do
    login_as :manager
    it 'return http succcess' do
      get :index
      expect(response).to have_http_status(:success)
    end
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

  describe 'POST #update' do
    let(:order) { FactoryGirl.create :order }
    login_as :manager
    it 'update order_item with valid attributes' do
      oi = order.order_items.first.decorate
      post :update, id: oi, order_item: { descr_basis: 'A', descr_assort: 'B', special_notes: 'C' }
      oi.reload
      expect(oi.additional).to eq('A / B / C')
    end
  end

end
