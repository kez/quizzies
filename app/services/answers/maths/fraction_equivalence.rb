class Answers::Maths::FractionEquivalence < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct

  def call
    return unless valid_for_this_question_type?
    self.correct = (input.to_s == question.answer)
    puts [self.class.name, correct]
  end

  private

  def this_question_type_key
    %w[fraction_equivalence]
  end

  def valid_for_this_question_type?
    this_question_type_key.include?(question.topic.key)
  end
end
