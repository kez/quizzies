class HomeController < ApplicationController
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # allow_browser versions: :modern

  allow_unauthenticated_access

  def home
    @title = "Quizzies.app - 11+ quizzes for free"
    @description = "Test your knowledge with our free 11+ quizzes. We have quizzes for English, Maths, Verbal Reasoning, and Non-Verbal Reasoning."
    @super_topic = SuperTopic.first

    @recent_quizzes = []
    # if session[:nanoid]
    #   @recent_quizzes << Quiz.includes(:topic).order("created_at desc").where(Arel.sql("data->>'session_nanoid' = ?", session[:nanoid])).limit(10).all
    # end
    if authenticated?
      @recent_quizzes << Quiz.includes(:topic).order("created_at desc").where(user_id: Current.session.user_id).limit(10).all
    end

    @recent_quizzes.flatten!
    @recent_quizzes.uniq!
  end
end
