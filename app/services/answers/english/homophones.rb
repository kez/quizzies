class Answers::English::Homophones < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct
  output :feedback

  def call
    return unless valid_for_this_question_type?
    self.correct = question.answer.to_s.downcase == input.to_s.downcase
    if correct
      self.feedback = "Correct - #{question.answer} is a homophone of #{question.title}"
    end
  end

  private

  def this_question_type_key
    "homophones"
  end

  def valid_for_this_question_type?
    question.topic.key == this_question_type_key
  end
end
