class Answers::SpellingPunctuation::IeEiWords < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct
  output :feedback

  def call
    return unless valid_for_this_question_type?

    self.correct = question.answers == [input.to_s.downcase[0], input.to_s.downcase[1]]
    if correct
      self.feedback = "Correct, the word #{question.data["word"]} is means  \"#{question.data["definition"]}\""
    end
  end

  private

  def this_question_type_key
    "ie_ei_words"
  end

  def valid_for_this_question_type?
    question.topic.key == this_question_type_key
  end
end
