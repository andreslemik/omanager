require 'rails_helper'

describe 'orders/new.html.slim' do
  before :each do
    @products = FactoryGirl.create_list(:product, 5)
    assign :order, Order.new
  end

  it 'form contain select box with product category' do
    render
    Category.find_each do |c|
      expect(rendered).to match /#{sanitize c.name}/
    end
  end
end