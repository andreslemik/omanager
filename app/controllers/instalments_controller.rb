class InstalmentsController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]

  def index
    @instalments = @order.instalments.page(params[:page])
    @title = 'Рассрочка по договору №' << @order.dog_num_s
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end
