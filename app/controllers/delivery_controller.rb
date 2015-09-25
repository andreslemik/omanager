# Delivery controller
class DeliveryController < ApplicationController
  before_action :set_order_item, only: [:edit, :update, :well_done]

  def index
    @title = 'Поставить на доставку'
    @items = OrderItem.ready
                 .by_desired_date
                 .includes(:order, :product)
                 .page(params[:page])
  end

  def edit
    @title = 'Постановка изделия на доставку'
  end

  private

  def set_order_item
    @order_item = OrderItem.find params[:id]
  end
end