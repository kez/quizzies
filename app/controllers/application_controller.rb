class ApplicationController < ActionController::Base
  include Authentication
  include ActionController::Cookies
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # allow_browser versions: :modern

  before_action :set_session
  before_action :set_breadcrumbs

  private

  def set_session
    if session[:nanoid].nil? && cookies[:nanoid].nil?
      session[:nanoid] = Nanoid.generate
      cookies[:nanoid] = session[:nanoid]
    elsif session[:nanoid].nil? && !cookies[:nanoid].nil?
      session[:nanoid] = cookies[:nanoid]
    end

    if !session[:nanoid].nil? && cookies[:nanoid].nil?
      cookies[:nanoid] = session[:nanoid]
    end
  end

  def set_breadcrumbs
    @breadcrumbs = [["Home", root_url]]
  end
end
