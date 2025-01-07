class Answers::VerbalReasoning::WordLadders < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct
  output :feedback

  def call
    return unless valid_for_this_question_type?
    self.correct = question.answers == input.map { |s| s.downcase }
    if correct
      self.feedback = "Correct!"
    end
  end

  private

  def this_question_type_key
    "word_ladders"
  end

  def valid_for_this_question_type?
    question.topic.key == this_question_type_key
  end
end
