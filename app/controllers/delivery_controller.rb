# Delivery controller
class DeliveryController < ApplicationController
  before_action :set_order_item, only: [:edit, :update,
                                        :well_done, :well_done_form]
  before_action :scheduled_items, only: [:schedule, :edit]

  def index
    @title = 'Поставить на доставку'
    source = OrderItem.ready
             .by_desired_date
             .includes(:order, :product)
             .order('orders.dog_num asc, orders.area asc')
             .page(params[:page])
    @items = OrderItemDecorator.decorate_collection source
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
        f.html do
          redirect_to schedule_delivery_index_path,
                      notice: 'Изделие успешно поставлено в очередь на доставку'
        end
      else
        f.html { render :edit }
      end
    end
  end

  def well_done_form
  end

  def well_done
    respond_to do |f|
      if @order_item.update(done_params)
        @order_item.well_done! if @order_item.order.internal?
        @order_item.to_customer! unless @order_item.order.internal?
        f.html { redirect_to schedule_delivery_index_path, notice: 'Выполнено' }
      else
        f.html { render :schedule }
      end
    end
  end

  def print_schedule
    @date = Date.parse(params[:sdate])
    source = OrderItem.delivery.where(delivery_date: @date)
    @items = OrderItemDecorator.decorate_collection source
    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = \
          'attachment; filename = "Доставка на ' << \
          @date.strftime('%d-%m-%Y') << '.xlsx"'
      end
    end
  end

  private

  def set_order_item
    @order_item = OrderItem.find(params[:id]).decorate
  end

  def item_params
    params.require(:order_item).permit(:delivery_date)
  end

  def done_params
    params.require(:order_item).permit(:delivery_cost, :dept_id)
  end

  def scheduled_items
    @items = OrderItemDecorator
                 .decorate_collection(OrderItem.delivery
                                          .joins(:order).order('orders.area, orders.id'))
  end
end
