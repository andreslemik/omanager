# Products controller
class ProductsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def by_category_mfc
    category = Category.find(params[:category_id])
    @products = Product.where(category: category)
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
  end

  def option_values
    @product = Product.find(params[:product_id])
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
