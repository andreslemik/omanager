class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?
  before_action :authenticate_user!

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
    Rails.logger.error("Redirected by #{caller(1).first rescue 'unknown'}")
  end

  def get_query(cookie_key)
    cookies.delete(cookie_key) if params[:clear]
    cookies[cookie_key] = params[:q].to_json if params[:q]
    @query = params[:q].presence || JSON.load(cookies[cookie_key])
  end

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def user_for_paper_trail
    user_signed_in? ? current_user.id : 'неизвестный пользователь'
  end

end
