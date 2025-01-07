class Answers::Maths::MultiplicationDivisionOrOther < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct

  def call
    return unless valid_for_this_question_type?
    self.correct = Float(input) == Float(question.answer)
    puts [self.class.name, correct]
  end

  private

  def this_question_type_key
    %w[multiplication_division ratio place_value_multiplication_division place_values]
  end

  def valid_for_this_question_type?
    this_question_type_key.include?(question.topic.key)
  end
end
