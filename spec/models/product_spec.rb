require 'rails_helper'

RSpec.describe Product, type: :model do
  before :all do
    @product = create :product
  end
  it 'price_mod type 0 without price modificators ids return 10000' do
    expect(@product.price_mod(0)).to eq 10_000
  end
  it 'price_mod type 1 without price modificators ids return 12500' do
    expect(@product.price_mod(1)).to eq 12_500
  end

  it 'long_name return full proudct name include category' do
    expect(@product.long_name).to eq(
      "#{@product.category.name}: #{@product.name} (#{@product.manufacturer.name})")
  end
end
