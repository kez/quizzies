class Answers::English::CommonlyConfusedWords < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct
  output :feedback

  def call
    return unless valid_for_this_question_type?
    self.correct = question.answer.to_s.downcase == input.to_s.downcase

    if correct
      self.feedback = "Correct - the word #{question.answer} means \"#{question.data["definition"]}\""
    end
  end

  private

  def this_question_type_key
    "commonly_confused_words"
  end

  def valid_for_this_question_type?
    question.topic.key == this_question_type_key
  end
end
