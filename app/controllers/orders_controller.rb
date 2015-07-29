# Order controller
class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.includes(:dept, :author)
  end

  def show
  end

  def edit
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

  def update
    respond_to do |f|
      if @order.update(order_params)
        f.html { redirect_to @order, notice: 'Договор успешно изменен' }
      else
        f.html { render :edit }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |f|
      f.html { redirect_to orders_url, notice: 'Договор удалён' }
    end
  end

  private

  def set_order
    @order = Order.find params[:id]
  end

  def order_params
    params.require(:order).permit(:id, :order_date, :memo, :dept_id, :author_id)
  end
end