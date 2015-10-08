require 'rails_helper'

describe 'fabrication/index.html.slim' do
  before :each do
    assign :orders, FactoryGirl.create_list(:order, 5)
    assign :items, Kaminari.paginate_array(OrderItem.pending
                       .to_fabrication
                       .own_supplier
                       .by_desired_date
                       .includes(:order, :product)).page(1)
  end

  it 'render index work' do
    render
    expect(render).to match /Параметры/
  end
end
