require 'rails_helper'

describe 'order_items/stores.html.slim' do
  before :each do
    FactoryGirl.create :dept, name: 'Империя'
    assign :depts, Kaminari.paginate_array(Dept.all).page(1)
  end

  it 'stores are worling' do
    render
    expect(rendered).to match /Империя/
  end
end