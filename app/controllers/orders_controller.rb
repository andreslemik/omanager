# Order controller
class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.includes(:dept, :author).order(order_date: :desc).page(params[:page])
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
    @order.author_id = current_user.id
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
    params.require(:order).permit(:id, :order_date, :memo, :dept_id, :dog_num,
      :client, :phone, :address, :area, :partner_id, :retail_client,
      order_items_attributes: [:id, :product_id, :amount, :cost, :_destroy, option_values: []])
  end
end
