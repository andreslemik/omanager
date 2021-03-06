# Order controller
class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :edit_type, :update, :destroy]

  unless Rails.env.test?
    authorize_actions_for Order
    authority_actions internals: 'read'
    authority_actions edit_type: 'update'
  end

  def index
    @q = Order.without_internals.ransack(params[:q])
    @orders_total = Order.without_internals.size
    source = @q.result(distinct: true)
             .includes(:dept, :author, :products, :categories)
             .order(order_date: :desc).page(params[:page])
    @orders = OrderDecorator.decorate_collection(source)
    @title = 'Список договоров'
    @path = orders_path
  end

  def internals
    @q = Order.internals.ransack(params[:q])
    @orders_total = Order.internals.size
    source = @q.result(distinct: true)
              .includes(:dept, :author, :products, :categories)
              .order(order_date: :desc).page(params[:page])
    @orders = OrderDecorator.decorate_collection(source)
    @title = 'Внутренние заказы'
    @path = internals_orders_path
    render :index
  end

  def show
    session[:back] ||= request.referer
    @account = Account.new
    @title = @order.to_s
  end

  def edit
    authorize_action_for(@order)
  end

  def edit_type
    authorize_action_for(@order)
    @title = 'Изменение типа договора'
    session[:back] = request.referrer
    @order_type = params[:order_type] || @order.order_type
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @order = Order.new
    @order.order_items.build
  end

  # :nocov:
  def create
    @order = Order.new order_params
    @order.author_id = current_user.id
    respond_to do |f|
      if @order.save
        f.html { redirect_to @order, notice: 'Договор успешно добавлен' }
      else
        f.html { render :new }
      end
    end
  end

  def update
    respond_to do |f|
      if @order.update(order_params)
        f.html { redirect_to @order, notice: 'Договор успешно изменен' }
      else
        f.html do
          action = @order.order_type_changed? ? :edit_type : :edit
          render action
        end
      end
    end
  end
  # :nocov:

  def destroy
    authorize_action_for @order
    respond_to do |f|
      if @order.destroy
        f.html { redirect_to orders_url, notice: 'Договор удалён' }
      else
        f.html { render :edit, notice: 'Невозможно удалить договор' }
      end
    end
  end

  private

  def set_order
    source = Order.unscoped.find params[:id]
    @order = OrderDecorator.decorate source
  end

  def order_params
    params.require(:order).permit(:id, :order_date, :memo, :dept_id, :dog_num, :order_type,
                                  :client, :phone, :address, :area, :partner_id, :retail_client,
                                  :desired_date,
                                  order_items_attributes: [:id, :product_id, :amount, :cost, :_destroy,
                                                           :delivery_cost, :lift_cost, :install_cost,
                                                           :descr_basis, :descr_assort, :special_notes,
                                                           :memo,
                                                           option_values: []])
  end
end
