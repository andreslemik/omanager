# Accounts controller
class AccountsController < ApplicationController
  before_action :find_accounter

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

  private

  def find_accounter
    @klass = params[:accounter_type].capitalize.constantize
    @accounter = @klass.find(params[:accounter_id])
  end

  def account_params
    params.require(:account).permit(:operation_type, :operation_date, :amount, :memo)
  end
end
