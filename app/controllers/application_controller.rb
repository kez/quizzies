class ApplicationController < ActionController::Base
  include Authentication
  include ActionController::Cookies
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # allow_browser versions: :modern

  allow_unauthenticated_access
  before_action :set_session

  def home
    @super_topic = SuperTopic.first

    @recent_quizzes = []
    if session[:nanoid]
      @recent_quizzes = Quiz.includes(:topic).order("created_at desc").where(Arel.sql("data->>'session_nanoid' = ?", session[:nanoid])).limit(10).all
    end
  end

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
end
