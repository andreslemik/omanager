class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @order = Order.new
    @order.order_items.build
  end

  def create
    @order = Order.new order_params
    respond_to do |f|
      if @order.save
        f.html { redirect_to @order, notice: 'Договор успешно добавлен' }
      else
        f.html { render :new }
      end
    end
  end

  private

  def set_order
    @order = Order.find params[:id]
  end

  def order_params
    params.require(:order).permit(:id, :order_date, :memo)
  end
end
