class HomeController < ApplicationController
  PAGES = %w(orders accounting production delivery store)
  def index
  end

  def nav
    page = PAGES.select { |p| p == params[:page] }.first
    raise ActionController::RoutingError.new('Page Not Found') if page.blank?
    render "home/#{page}"
  end
end
