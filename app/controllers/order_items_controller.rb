class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:edit, :update]
  before_action :set_order, only: [:new, :create]

  def index
    @title = 'Архив изделий'
    @q = OrderItem.to_fabrication.ransack(params[:q])
    source = @q.result(distinct: true)
                       .order(id: :desc, order_id: :asc)
                       .page(params[:page])
    @order_items = OrderItemDecorator.decorate_collection(source)
  end

  def new
    @order_item = @order.order_items.build(amount: 1)
    @categories = Category.joins(:products).group(:id)
    @manufacturers = []
    @products = []
  end

  def edit
    @categories = Category.joins(:products).group(:id)
    @manufacturers = Partner.joins(:products).where('products.manufacturer_id IN (?)',
                                                    @order_item.product.manufacturer_id).uniq
    @products = Product.where(category: @order_item.product.category)
                    .where(manufacturer: @order_item.product.manufacturer)
  end

  def update
    respond_to do |format|
      if @order_item.update(item_params)
        format.html { redirect_to edit_order_path(@order_item.order), notice: 'Позиция заказа изменена.' }
        format.json { render :show, status: :ok, location: @order_item }
      else
        format.html { render :edit }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
   @order_item = @order.order_items.build(item_params)
   if @order_item.save
     redirect_to edit_order_path(@order), notice: 'Позиция заказа добавлена'
   else
     render action: 'new'
   end
  end

  private

  def item_params
    params.require(:order_item).permit(:id, :product_id, :amount, :cost, :_destroy,
                                       :descr_basis, :descr_assort, :special_notes,
                                       option_values: [])
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id]).decorate
  end

  def set_order
    @order = Order.find(params[:order_id])
  end
end
