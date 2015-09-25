# Delivery controller
class DeliveryController < ApplicationController
  before_action :set_order_item, only: [:edit, :update, :well_done]

  def index
    @title = 'Очередь доставки'
    @items = OrderItem.delivery
                 .by_desired_date
                 .includes(:order, :product)
                 .page(params[:page])
  end
end