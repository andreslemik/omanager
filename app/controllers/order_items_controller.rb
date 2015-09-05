class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:edit, :update]
  def new
    @order = Order.find params[:order_id]
    @order_item = OrderItem.new
  end

  def edit
    @categories = Category.joins(:products).group(:id)
    @manufacturers = Partner.joins(:products).where('products.manufacturer_id IN (?)',
                                                    @order_item.product.manufacturer_id).uniq
    @products = Product.where(category: @order_item.product.category)
                    .where(manufacturer: @order_item.product.manufacturer)
  end

  def update
    respond_to do |format|
      if @order_item.update(item_params)
        format.html { redirect_to edit_order_path(@order_item.order), notice: 'Позиция заказа изменена.' }
        format.json { render :show, status: :ok, location: @order_item }
      else
        format.html { render :edit }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def item_params
    params.require(:order_item).permit(:id, :product_id, :amount, :cost, :_destroy,
                                       :descr_basis, :descr_assort, :special_notes,
                                       option_values: [])
  end

  def set_order_item
    @order_item = OrderItem.find params[:id]
  end
end