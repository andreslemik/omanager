class InstalmentsController < ApplicationController
  before_action :set_order, only: [:index, :new, :create]
  before_action :set_instalment, only: [:destroy, :edit, :update]
  before_action :set_back_path, only: [:new, :edit, :destroy]

  def index
    @instalments = @order.instalments.page(params[:page])
    @title = 'Рассрочка по договору №' << @order.dog_num_s
  end

  def edit
    @title = 'Редактирование платежа (рассрчка)'
  end

  def new
    @instalment = Instalment.new
    @title = 'Новый платеж'
    session[:back] = request.referrer
  end

  def create
    @instalment = @order.instalments.build instalment_params
    respond_to do |f|
      if @instalment.save
        f.html { redirect_to session.delete(:back), notice: 'Платеж добавлен' }
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
    respond_to do |f|
      if @instalment.destroy
        f.html { redirect_to session[:back_inst], notice: 'Платеж удалён' }
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

  def set_back_path
    session[:back_inst] = request.referer
  end

end
