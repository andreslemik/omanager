class OrderItemsController < ApplicationController
  def new
    @order = Order.find params[:order_id]
    @order_item = OrderItem.new
  end

  def edit
    @order_item = OrderItem.find params[:id]
  end

  private

  def item_params
    params.require(:order_item).permit(:id, :product_id, :amount, :cost, :_destroy,
                                       :descr_basis, :descr_assort, :special_notes,
                                       option_values: [])
  end
end
