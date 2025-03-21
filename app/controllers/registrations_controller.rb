class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  before_action :resume_session, only: :new
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    redirect_to root_url, notice: "You are already signed in." if authenticated?
  end

  def create
    user = User.new(params.permit(:email_address, :password))
    if user.save
      start_new_session_for user
      user.update(nanoid: session[:nanoid] || Nanoid.generate)

      if session[:nanoid]
        Rails.logger.info "Updating quizzes for user #{user.id} with session #{session[:nanoid]}"
        Quiz.where(Arel.sql("data->>'session_nanoid' = ?", session[:nanoid])).update(user_id: user.id)
      end

      redirect_to after_authentication_url, notice: "Signed up."
    else
      redirect_to new_registration_url(email_address: params[:email_address]), alert: user.errors.full_messages.to_sentence
    end
  end
end
