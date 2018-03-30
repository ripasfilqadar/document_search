class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  helper_method :current_user


  def current_user
    return @current_user if defined? @current_user
    current_user!
  rescue
    nil
  end

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  private
  def current_user!
    @current_user = (current_user_session && current_user_session.user)
    @current_user.access_ip = request.remote_ip if @current_user
    @current_user
  end
end
