require 'rails_helper'

describe 'fabrication/index.html.slim' do
  before :each do
    assign :order, FactoryGirl.create(:order)
    source = OrderItem.pending
                 .to_fabrication
                 .own_supplier
                 .by_desired_date
                 .includes(:order, :product)
    assign :items, Kaminari.paginate_array(
                               OrderItemDecorator.decorate_collection(source)
                 ).page(1)
  end

  it 'render index work' do
    render
    expect(render).to match /Цвет подбор/
  end
end
