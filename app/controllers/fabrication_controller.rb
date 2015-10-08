# Fabrication controller
class FabricationController < ApplicationController
  before_action :set_order_item, only: [:edit, :update, :get_ready, :set_dept]
  before_action :working_items, only: [:schedule, :edit]
  def index
    @title = 'Поставить в очередь'
    source = OrderItem.pending
             .to_fabrication
             .own_supplier
             .by_desired_date
             .includes(:order, :product)
             .page(params[:page])
    @items = OrderItemDecorator.decorate_collection(source)
  end

  def edit
    @title = 'Постановка изделия в очередь'
  end

  def update
    respond_to do |f|
      if @order_item.update(item_params)
        f.html { redirect_to request.referrer, notice: 'Операция выполнена' }
      else
        f.html { render :edit }
      end
    end
  end

  def get_ready
    @order_item.get_ready!
    redirect_to :back
  end

  def set_dept
    respond_to { |f| f.js }
  end

  def schedule
    @title = 'Очередь производства'
  end

  def to_order
    source = OrderItem.to_order
             .joins(:product)
             .order('partners.name', 'products.name')
             .page(params[:page])
    @items = OrderItemDecorator.decorate_collection source
  end

  def print_schedule
    source = OrderItem.working.order(:fabrication_date, :id)
    @items = OrderItemDecorator.decorate_collection source
    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="График производства.xlsx"'
      end
    end
  end

  def print_orders
    manufacturer = Partner.find(params[:manufacturer_id])
    source = OrderItem.to_order
             .where('partners.id = ?', manufacturer.id)
    @items = OrderItemDecorator.decorate_collection source
    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = \
          'attachment; filename = "Заказ для ' << manufacturer.name << '.xlsx"'
      end
    end
  end

  private

  def set_order_item
    @order_item = OrderItem.find params[:id]
  end

  def working_items
    source = OrderItem.working
             .includes(:order, :product)
             .order(:fabrication_date, :id)
    @items = OrderItemDecorator.decorate_collection(source)
  end

  def item_params
    params.require(:order_item).permit(:fabrication_date, :dept_id)
  end
end
