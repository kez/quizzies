class Answers::English::Antonyms < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct

  def call
    pp valid_for_this_question_type?
    pp question.topic.key
    pp this_question_type_key
    return unless valid_for_this_question_type?
    pp question.answers
    pp input
    pp question.answers.include?(input.to_s.downcase)
    self.correct = question.answers.include?(input.to_s.downcase)
  end

  private

  def this_question_type_key
    "antonyms"
  end

  def valid_for_this_question_type?
    question.topic.key == this_question_type_key
  end
end
