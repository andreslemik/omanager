class HomeController < ApplicationController
  PAGES = %w(orders accounting production delivery store)
  def index
  end

  def nav
    page = PAGES.find { |p| p == params[:page] }
    raise ActionController::RoutingError.new('Page Not Found') if page.blank?
    render "home/#{page}"
  end
end
