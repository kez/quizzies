class Answers::SpellingPunctuation::Spellings < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct

  def call
    return unless valid_for_this_question_type?

    self.correct = question.answer.to_s.downcase == input.to_s.downcase
  end

  private

  def this_question_type_keys
    %w[spellings difficult-spellings]
  end

  def valid_for_this_question_type?
    this_question_type_keys.include?(question.topic.key)
  end
end
