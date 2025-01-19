class Quiz < ApplicationRecord
  has_prefix_id :q
  belongs_to :topic
  belongs_to :user, optional: true
  has_many :quiz_questions
  has_many :questions, through: :quiz_questions, class_name: "QuizQuestion"

  def finished?
    quiz_questions.all? { |qq| qq.answered? || qq.skipped? }
  end
end
