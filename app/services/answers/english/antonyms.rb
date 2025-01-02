class Answers::English::Antonyms < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct

  def call
    return unless valid_for_this_question_type?

    self.correct = question.answers.include?(input.to_s.downcase)

    if correct
      self.feedback = "Correct - #{question.answer} is an antonym of #{question.title}"
    end
  end

  private

  def this_question_type_key
    "antonyms"
  end

  def valid_for_this_question_type?
    question.topic.key == this_question_type_key
  end
end
