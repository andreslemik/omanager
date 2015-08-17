# Partners controller
class PartnersController < ApplicationController

  def index
    @partners = Partner.page(params[:page])
  end

end