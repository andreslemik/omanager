# Delivery controller
class DeliveryController < ApplicationController
  before_action :set_order_item, only: [:edit, :update, :well_done]
  before_action :scheduled_items, only: [:schedule, :edit]

  def index
    @title = 'Поставить на доставку'
    @items = OrderItem.ready
                 .by_desired_date
                 .includes(:order, :product)
                 .page(params[:page])
  end

  def schedule
    @title = 'Очередь доставки'
  end

  def edit
    @title = 'Постановка изделия на доставку'
  end

  def update
    respond_to do |f|
      if @order_item.update(item_params)
        f.html { redirect_to schedule_delivery_index_path,
                             notice: 'Изделие успешно поставлено в очередь на доставку' }
      else
        f.html { render :edit }
      end
    end
  end

  def well_done
    @order_item.well_done!
    redirect_to schedule_delivery_index_path
  end

  def print_schedule
    @date = Date.parse(params[:sdate])
    @items = OrderItem.delivery.where(delivery_date: @date)
    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = \
          'attachment; filename = "Доставка на ' << @date.strftime('%d-%m-%Y') << '.xlsx"'
      end
    end
  end

  private

  def set_order_item
    @order_item = OrderItem.find params[:id]
  end

  def item_params
    params.require(:order_item).permit(:delivery_date)
  end

  def scheduled_items
    @items = OrderItem.delivery
  end
end