# Accounts controller
class AccountsController < ApplicationController
  before_action :find_accounter, only: [:create]
  before_action :set_account, only: [:edit, :update, :destroy]

  authorize_actions_for Account
  authority_actions incomes: 'read'

  def edit
    authorize_action_for @account
  end

  def incomes
    @title = 'Поступления по датам и подразделениям'
    @incomes = Kaminari.paginate_array([Account.income
                                           .order(operation_date: :desc)
                                           .group(:operation_date).sum(:amount)]).page(params[:page])
    if params[:date]
      @date = Time.at(params[:date].to_i).to_date
      @details = Account.income.where(operation_date: @date).group(:dept_id).sum(:amount)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @accounter = @account
    respond_to do |f|
      if @account.update(account_params)
        case @account.accountable_type
        when 'Partner'
          redirect = -> { redirect_to partner_path(@account.accountable_id), notice: 'Запись успешно изменена' }
        when 'Order'
          redirect = -> { redirect_to order_path(@account.accountable_id), notice: 'Запись успешно изменена' }
        end
        f.html { redirect.call }
      else
        f.html { render :edit }
      end
    end
  end

  def create
    @account = @accounter.operations.new(account_params)
    respond_to do |format|
      if @account.save
        format.html do
          flash[:notice] = 'Запись успешно добавлена'
          redirect_to controller: @accounter.class.to_s.pluralize.downcase,
                      action: :show, id: @accounter.id
        end
      else
        format.html do
          flash[:error] = 'Запись не добавлена'
          redirect_to controller: @accounter.class.to_s.pluralize.downcase,
                      action: :show, id: @accounter.id
        end
      end
    end
  end

  def destroy
    authorize_action_for @account
    @account.destroy
    respond_to do |f|
      case @account.accountable_type
        when 'Partner'
          redirect = -> { redirect_to partner_path(@account.accountable_id), notice: 'Запись успешно удалена' }
        when 'Order'
          redirect = -> { redirect_to order_path(@account.accountable_id), notice: 'Запись успешно удалена' }
      end
      f.html { redirect.call }
    end
  end

  private

  def find_accounter
    allowed_types = %w(order partner)
    fail 'Not allowed parameter' unless allowed_types.include? params[:accounter_type]
    accounter_type = params[:accounter_type]
    klass = accounter_type.capitalize.constantize
    @accounter = klass.find(params[:accounter_id])
  end

  def set_account
    @account = Account.find params[:id]
    klass = @account.accountable_type.capitalize.constantize
    @accounter = klass.find(@account.accountable_id)
  end

  def account_params
    params.require(:account)
      .permit(:operation_type, :operation_date, :amount, :memo, :dept_id)
  end
end
