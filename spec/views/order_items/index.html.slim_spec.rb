require 'rails_helper'

describe 'order_items/index.html.slim' do
  before :each do
    assign :orders, FactoryGirl.create_list(:order, 5)
    assign :q, OrderItem.to_fabrication.ransack(params[:q])
    assign :order_items, Kaminari.paginate_array(
                           OrderItem.to_fabrication
                       ).page(1)
  end

  it 'order_items index are working' do
    render
    expect(rendered).to match /Договор/
  end
end
