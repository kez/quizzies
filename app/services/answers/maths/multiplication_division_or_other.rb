class Answers::Maths::MultiplicationDivisionOrOther < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct

  def call
    return unless valid_for_this_question_type?
    self.correct = input.to_f == question.answer.to_f
    puts [self.class.name, self.correct]
  end

  private

  def this_question_type_key
    %w[multiplication_division ratio]
  end

  def valid_for_this_question_type?
    [this_question_type_key].include?(question.key)
  end
end
