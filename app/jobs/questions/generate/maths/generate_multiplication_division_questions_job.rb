# Questions::Generate::Maths::GenerateMultiplicationDivisionQuestionsJob.perform_now
class Questions::Generate::Maths::GenerateMultiplicationDivisionQuestionsJob < ApplicationJob
  queue_as :default

  def perform(questions_to_generate = 10)
    questions = []

    questions_to_generate.times do
      # Randomly decide between multiplication or division
      type = [:multiplication, :division].sample

      if type == :multiplication
        # Generate multiplication question
        num1 = rand(2..20) # Multiplier 1 (up to 20 for reasonable questions)
        num2 = rand(2..20) # Multiplier 2
        answer = num1 * num2
        questions << {
          question: "#{num1} × #{num2} = ?",
          answer: answer
        }
      else
        # Generate division question
        numerator = rand(1..100) # Numerator up to 100
        denominator = rand(1..9) # Denominator less than 10
        quotient = numerator / denominator
        # Ensure the numerator is divisible by the denominator for clean answers
        numerator = quotient * denominator
        questions << {
          question: "#{numerator} ÷ #{denominator} = ?",
          answer: quotient
        }
      end
    end

    # Generate and print the math questions
    questions
  end
end
