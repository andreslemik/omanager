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
        @order_item.reload
        if @order_item.order.internal? || !@order_item.dept_id.nil?
          @order_item.well_done!
          @order_item.get_ready! if @order_item.order.retail? && @order_item.may_get_ready?
        else
          if @order_item.may_to_customer?
            @order_item.to_customer!
          else
            f.html { redirect_to schedule_delivery_index_path, error: 'Не выполнено' }
          end
        end
        f.html { redirect_to order_path(@order_item.order), notice: 'Выполнено' }
      else
        f.html { render :schedule }
      end
    end
  end

  def print_schedule
    @date = Time.at(params[:sdate].to_i).to_date
    source = OrderItem.delivery.where(delivery_date: @date)
             .joins(:order).order('orders.area, orders.id')
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
    params.require(:order_item).permit(:delivery_date, :delivery_memo)
  end

  def done_params
    params.require(:order_item).permit(:delivery_cost, :dept_id)
  end

  def scheduled_items
    @items = OrderItem.delivery
             .joins(:order).order('orders.area, orders.id')
  end
end
