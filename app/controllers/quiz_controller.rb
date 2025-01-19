class QuizController < ApplicationController
  allow_unauthenticated_access
  def new
    @title = "Start a New Quiz"

    # @topic = Topic.find_by_prefix_id(params[:topic])
    @topic = Topic.find_by(key: params[:topic])
    @super_topic = SuperTopic.find_by(key: params[:super_topic])

    # @breadcrumbs << ["New #{@topic.title} Quiz"]
  end

  def subtopic
    @topic = Topic.find_by(key: params[:parent_topic])
    @super_topic = SuperTopic.find_by(key: params[:super_topic])
    @subtopic = Topic.find_by(key: params[:sub_topic])

    @breadcrumbs << ["New #{@topic.title} Quiz", new_quiz_seo_url(@super_topic.key, @topic.key)]
    @breadcrumbs << [@subtopic.title]
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

    quiz = Quiz.new(topic: topic, status: 0, user_id: current_session&.user_id)

    sub_topics = topic.sub_topics.map { |sub_topic| sub_topic.id }
    potential_questions = Question.select(:id, :topic_id).where(topic_id: sub_topics).all.shuffle
    quizzes_for_this_user = Quiz.where(Arel.sql("data->>'session_nanoid' is not null")).where(Arel.sql("data->>'session_nanoid' = ?", session[:nanoid])).pluck(:id)
    answered_questions_for_this_user = QuizQuestion.where(quiz_id: quizzes_for_this_user).pluck(:question_id)

    sorted_potential_questions = potential_questions.sort_by do |question|
      answered_questions_for_this_user.include?(question.id) ? 1 : 0
    end.group_by(&:topic_id)

    question_topic_ids = sorted_potential_questions.keys
    question_topic_idx = 0
    final_questions = []

    question_count.times do
      topic_id_for_this = question_topic_ids[question_topic_idx]
      puts "Shifting for topic #{topic_id_for_this}"
      this_question = sorted_potential_questions[topic_id_for_this].shift
      next unless this_question

      while final_questions.include?(this_question)
        this_question = sorted_potential_questions[topic_id_for_this].shift
      end

      final_questions << this_question

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

  private

  def current_session
    Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
  end
end
