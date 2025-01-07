# reload! &&  Questions::Generate::Maths::GeneratePlaceValueMultiplicationDivisionJob.perform_now(10)
class Questions::Generate::Maths::GeneratePlaceValueMultiplicationDivisionJob < ApplicationJob
  queue_as :default

  def perform(questions_to_generate = 50)
    @questions_to_generate = questions_to_generate
    questions = []
    operators = ["*", "*", "*", "*", "/"]
    main_vals = (1..30).to_a
    place_vals = (1..99).to_a
    tens = [10, 100]

    @questions_to_generate.times do
      operator = operators.sample
      main_val = main_vals.sample
      tens_val = tens.sample
      place_val = place_vals.sample

      number = "#{main_val}.#{place_val}".to_f

      question = "#{main_val}.#{place_val} #{operator} #{tens_val}"
      answer = number.send(operator, tens_val).round(4)
      if answer.to_s.end_with?(".0")
        answer = answer.to_i
      end
      puts question
      questions << {
        question: "Work out #{question.tr("*", "x")}",
        answer:
      }
    end

    questions
  end

  #
end
