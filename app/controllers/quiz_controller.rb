class QuizController < ApplicationController
  def new
    @title = "Start a New Quiz"

    # @topic = Topic.find_by_prefix_id(params[:topic])
    @topic = Topic.find_by(key: params[:topic])
    @super_topic = SuperTopic.find_by(key: params[:super_topic])
  end

  def show
    @quiz = Quiz.includes(:questions).find_by_prefix_id(params[:id])
    @questions = QuizQuestion.where(quiz: @quiz).order(:ordinal)
    @super_topic = @quiz.topic.super_topic
    @topic = @quiz.topic
  end

  def create
    allowed_params = params.permit(:question_count, :topic)
    topic = Topic.find_by_prefix_id(allowed_params[:topic])
    question_count = allowed_params[:question_count].to_i

    quiz = Quiz.new(topic: topic, status: 0)

    sub_topics = topic.sub_topics.map { |sub_topic| sub_topic.id }
    questions = Question.where(topic_id: sub_topics).group_by(&:topic_id)

    question_topic_ids = questions.keys
    question_topic_idx = 0
    final_questions = []

    question_count.times do
      topic_id_for_this = question_topic_ids[question_topic_idx]
      _q = questions[topic_id_for_this]&.sample
      next unless _q

      while final_questions.include?(_q)
        _q = questions[topic_id_for_this].sample
      end

      final_questions << _q

      question_topic_idx += 1

      question_topic_idx = 0 if question_topic_idx >= question_topic_ids.size
    end

    quiz.data ||= {}
    quiz.data["session_nanoid"] = session[:nanoid]
    quiz.started_at = DateTime.now
    quiz.save

    final_questions.each_with_index do |question, ordinal|
      QuizQuestion.create(quiz_id: quiz.id, question: question, ordinal:)
    end

    ahoy.track "Quiz Created", {quid_id: quiz.id}

    redirect_to quiz_question_path(quiz.to_param, 0), notice: "Quiz created - good luck!", format: :html
  end
end
