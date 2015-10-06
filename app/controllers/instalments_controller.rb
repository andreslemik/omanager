class InstalmentsController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]
  before_action :set_instalment, only: [:destroy, :edit, :update]

  def index
    @instalments = @order.instalments.page(params[:page])
    @title = 'Рассрочка по договору №' << @order.dog_num_s
  end

  def edit
    @title = 'Редактирование платежа (рассрчка)'
  end

  def new
    session[:back_inst] = request.referer
    @instalment = Instalment.new
    @title = 'Новый платеж'
  end

  def create
    @instalment = @order.instalments.build instalment_params
    respond_to do |f|
      if @instalment.save
        f.html { redirect_to session[:back], notice: 'Платеж добавлен' }
      else
        f.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @instalment.update(instalment_params)
        format.html { redirect_to order_path(@instalment.order), notice: 'Платеж изменен' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    session[:back] = request.referer
    respond_to do |f|
      if @instalment.destroy
        f.html { redirect_to session[:back], notice: 'Платеж удалён' }
      else
        f.html { render :edit, notice: 'Невозможно удалить платеж'}
      end
    end
  end

  private

  def instalment_params
    params.require(:instalment).permit(:payment_date, :amount)
  end

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_instalment
    @instalment = Instalment.find(params[:id])
  end
end
