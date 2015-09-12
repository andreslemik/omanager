# Fabrication controller
class FabricationController < ApplicationController
  def index
    @items = OrderItem.pending.by_desired_date.includes(:order).page(params[:page])
  end
end
