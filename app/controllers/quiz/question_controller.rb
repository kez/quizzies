class Quiz::QuestionController < ApplicationController
  def show
    @quiz = Quiz.find_by_prefix_id(params[:quiz_id])
    # ordinal is passed in the id param
    @question = QuizQuestion.find_by(quiz: @quiz, ordinal: params[:id])
    @questions = QuizQuestion.where(quiz: @quiz).order(:ordinal)
  end

  def update
    quiz = Quiz.find_by_prefix_id(params[:quiz_id])

    @questions = QuizQuestion.where(quiz:).order(:ordinal)
    quiz_question = QuizQuestion.where(quiz:, ordinal: params[:id]).first
    allowed_params = params.permit(:answer, :answer0, :answer1, :skip)

    if allowed_params.key?(:skip)

      quiz_question.update(skipped: 1)

      if quiz_question.ordinal == @questions.count - 1
        ahoy.track "Quiz Completed", {quid_id: quiz.id}
        quiz.finished_at = DateTime.now if quiz.finished_at.nil
        quiz.save
        redirect_to quiz_path(quiz.to_param), flash: {success: "Quiz completed"} and return
      else
        redirect_to quiz_question_path(quiz.to_param, quiz_question.ordinal + 1), flash: {info: "You skipped that question"} and return
      end

    else
      quiz_question.update(attempts: (quiz_question.attempts || 0) + 1)
    end

    input = allowed_params[:answer] || [allowed_params[:answer0], allowed_params[:answer1]].compact
    actor = Answers::CheckAnswer.call(question: quiz_question.question, input:)
    answer_is_correct = actor.correct

    redirect_to quiz_question_path(quiz.to_param, quiz_question.ordinal), flash: {error: "That's not quite correct, try again or skip if you're stuck!"} and return unless answer_is_correct

    quiz_question.update(answered: 1)

    if quiz_question.ordinal == @questions.count - 1
      ahoy.track "Quiz Completed", {quid_id: quiz.id}
      quiz.finished_at = DateTime.now if quiz.finished_at.nil
      quiz.save
      redirect_to quiz_path(quiz.to_param), flash: {success: actor.feedback || "Quiz completed"}
    else
      redirect_to quiz_question_path(quiz.to_param, quiz_question.ordinal + 1), flash: {success: actor.feedback || "Correct answer"}
    end
  end
end
