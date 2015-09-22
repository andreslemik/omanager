# Fabrication controller
class FabricationController < ApplicationController
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

  def schedule
    @template = 'schedule'
    @title = 'Очередь производства'
    @items = OrderItem.working
                 .includes(:order, :product)
                 .page(params[:page])
    render :index
  end
end
