# Fabrication controller
class FabricationController < ApplicationController
  def index
    @items = OrderItem.pending
                 .to_fabrication
                 .own_supplier
                 .by_desired_date
                 .includes(:order, :product)
                 .page(params[:page])
  end
end
