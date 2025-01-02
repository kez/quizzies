class Questions::Generate::Maths::ProportionsOfNumbersJob < ApplicationJob
  queue_as :default

  def perform(questions_to_generate = 2)
    # Generate questions with whole-number answers only
    whole_number_questions = []
    percentages = [10, 20, 30, 40, 50, 60, 70, 80, 90] # Percentages in increments of 10
    fractions = [2, 3, 4, 5] # Fractions up to one-fifth

    while whole_number_questions.size < questions_to_generate
      amount = rand(50..200) # Random amount between £50 and £200
      percentage = percentages.sample # Select percentage in increments of 10
      fraction_denominator = fractions.sample # Select fraction up to one-fifth

      # Calculate potential answers
      percentage_answer = (percentage / 100.0) * amount
      fraction_answer = amount / fraction_denominator.to_f
      combined_answer = (percentage / 100.0) * fraction_answer

      # Check if all answers are whole numbers
      if percentage_answer % 1 == 0 && fraction_answer % 1 == 0 && combined_answer % 1 == 0
        # Question 1: Percentage of the amount
        whole_number_questions << {
          question: "#{percentage}% of £#{amount}",
          answer: percentage_answer.to_i
        }

        # Question 2: Fraction of the amount
        whole_number_questions << {
          question: "a 1/#{fraction_denominator} of £#{amount}",
          answer: fraction_answer.to_i
        }

        # Question 3: Combined percentage and fraction calculation
        whole_number_questions << {
          question: "#{percentage}% of one-#{fraction_denominator}th of £#{amount}",
          answer: combined_answer.to_i
        }
      end
    end

    # Convert to JSON

    whole_number_questions
  end
end
