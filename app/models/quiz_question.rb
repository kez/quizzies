class QuizQuestion < ApplicationRecord
  has_prefix_id :qq
  belongs_to :quiz
  belongs_to :question

  attr_accessor :answer
  def title
    question.title
  end
end
