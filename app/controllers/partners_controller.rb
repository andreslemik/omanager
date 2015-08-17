# Partners controller
class PartnersController < ApplicationController
  def index
    @partners = Partner.page(params[:page])
  end

  def show
    @partner = Partner.find params[:id]
    @operations = @partner.operations.order('operation_date desc, created_at desc').page(params[:page])
    @account = Account.new
  end
end
