require 'rails_helper'

describe 'New order feature', type: :feature do
  before :each do
    user = FactoryGirl.create :manager
    login_as user
    FactoryGirl.create_list :product, 5
  end
  context 'Choosing order type' do
    it 'choose dealer type', js: true do
      visit new_order_path
      within('#new_order') do
        choose 'order_order_type_dealer'
      end
      expect(page).to have_selector('.corporate', visible: true)
    end
    it 'choose internal order type', js: true do
      visit new_order_path
      within('#new_order') do
        choose 'order_order_type_internal'
      end
      expect(page).to have_selector('#client_definition', visible: false)
    end
  end
  context 'Creating order' do
    it 'select product will get it price', js: true, driver: :selenium do
      visit new_order_path
      product = Product.all.sample
      within '#new_order' do
        fill_in 'order_client', with: 'Иванов Иван Иванович'
        fill_in 'order_phone', with: '123-54-23'
        fill_in 'order_address', with: 'Ленина, 1'
        select 'Центр', from: 'order_area'

        select product.category.name, from: 'order_order_items_attributes_0_category'
        select product.manufacturer.name, from: 'order_order_items_attributes_0_manufacturer'
        select product.name, from: 'order_order_items_attributes_0_product_id'
      end
      expect(find_field('order_order_items_attributes_0_cost').value).to eq(product.price.to_s)
    end

    it 'price change', js: true, driver: :selenium do
      product = Product.all.sample
      ov = product.product_option_values.sample
      price = product.price_mod(0, [ov.option_value_id])
      visit new_order_path
      within '#new_order' do
        select product.category.name, from: 'order_order_items_attributes_0_category'
        select product.manufacturer.name, from: 'order_order_items_attributes_0_manufacturer'
        select product.name, from: 'order_order_items_attributes_0_product_id'

        select ov.option_value.name, from: 'order_order_items_attributes_0_option_values'
      end
      expect(find_field('order_order_items_attributes_0_cost').value).to eq(price.to_s)
      # sleep(inspection_time=5)
    end
  end
end
