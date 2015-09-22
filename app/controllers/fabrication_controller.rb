# Fabrication controller
class FabricationController < ApplicationController
  before_action :set_order_item, only: [:edit, :update]
  before_action :working_items, only: [:schedule, :edit]
  def index
    @template = 'fabrication'
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

  def schedule
    @template = 'schedule'
    @title = 'Очередь производства'
    render :index
  end

  def print_schedule
    @items = OrderItem.working.where(fabrication_date: params[:fdate])
    respond_to do |format|
      format.xlsx
    end
  end

  private

  def set_order_item
    @order_item = OrderItem.find params[:id]
  end

  def working_items
    @items = OrderItem.working
                 .includes(:order, :product)
  end

  def item_params
    params.require(:order_item).permit(:fabrication_date)
  end
end
