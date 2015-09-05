# Products controller
class ProductsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def by_category_mfc
    category = Category.find(params[:category_id])
    manufacturer = Partner.find(params[:manufacturer_id])
    @products = Product.where(category: category)
                .where(manufacturer: manufacturer)
  end

  def manufacturers
    category = Category.find(params[:category_id])
    @products = Product.where(category: category)
    @manufacturers = Partner.joins(:products)
                     .where('products.manufacturer_id IN (?)',
                            @products.pluck(:manufacturer_id).uniq).uniq
  end

  def price
    @product = Product.find(params[:product_id])
    @mods = params[:mods].split(',').map(&:to_i) if params[:mods]
    @type_id = params[:type_id]
  end

  def option_values
    @product = Product.find(params[:product_id])
    @option_values = @product.product_option_values
    @option_types = @product.product_option_types
    @attr_id = params[:attr_id]

    case params[:m_name]
    when 'order'
      @select_id = "order[order_items_attributes][#{@attr_id}]"
      @select_name = "order[order_items_attributes][#{@attr_id}][option_values][]"
    when 'order_item'
      @select_id = 'order_item[optoin_values]'
      @select_name = 'order_item[option_values][]'
    end

    respond_to do |f|
      f.json
      f.js
    end
  end

  protected

  def record_not_found
    render nothing: true, status: 404
  end
end
