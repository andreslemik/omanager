# Products controller
class ProductsController < ApplicationController
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
end
