class Answers::English::BestMissingWords < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct

  def call
    return unless valid_for_this_question_type?
    self.correct = question.answer.to_s.downcase == input.to_s.downcase
  end

  private

  def this_question_type_key
    "best_missing_words"
  end

  def valid_for_this_question_type?
    question.topic.key == this_question_type_key
  end
end
