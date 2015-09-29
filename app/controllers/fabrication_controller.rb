# Fabrication controller
class FabricationController < ApplicationController
  before_action :set_order_item, only: [:edit, :update, :get_ready]
  before_action :working_items, only: [:schedule, :edit]
  def index
    @title = 'Поставить в очередь'
    @items = OrderItem.pending
             .to_fabrication
             .own_supplier
             .by_desired_date
             .includes(:order, :product)
             .page(params[:page])
  end

  def edit
    @title = 'Постановка изделия в очередь'
  end

  def update
    respond_to do |f|
      if @order_item.update(item_params)
        f.html { redirect_to schedule_fabrication_index_path, notice: 'Изделие успешно поставлено в очередь' }
      else
        f.html { render :edit }
      end
    end
  end

  def get_ready
    @order_item.get_ready!
    redirect_to :back
  end

  def schedule
    @title = 'Очередь производства'
  end

  def to_order
    @items = OrderItem.to_order
             .joins(:product)
             .order('partners.name', 'products.name')
             .page(params[:page])
  end

  def print_schedule
    @items = OrderItem.working.order(:fabrication_date, :id)
    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="График производства.xlsx"'
      end
    end
  end

  def print_orders
    manufacturer = Partner.find(params[:manufacturer_id])
    @items = OrderItem.to_order
             .where('partners.id = ?', manufacturer.id)
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
    @items = OrderItem.working
             .includes(:order, :product)
             .order(:fabrication_date, :id)
  end

  def item_params
    params.require(:order_item).permit(:fabrication_date)
  end
end
