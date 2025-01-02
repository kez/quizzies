# Questions::Generate::Maths::GenerateRoundingQuestionsJob.perform_now
class Questions::Generate::Maths::GenerateRoundingQuestionsJob < ApplicationJob
  queue_as :default

  def perform(questions_to_generate = 10)
    # Generate a random number between 10,000 and 99,999
    number = rand(10_000..99_999)

    # Round the number to the nearest thousand
    rounded_number = (number / 1000.0).round * 1000

    # Generate some plausible but incorrect answers
    options = []
    options << rounded_number - 1000 if (rounded_number - 1000).between?(10_000, 99_999)
    options << rounded_number + 1000 if (rounded_number + 1000).between?(10_000, 99_999)
    options << rounded_number - 500 if (rounded_number - 500).between?(10_000, 99_999)
    options << rounded_number + 500 if (rounded_number + 500).between?(10_000, 99_999)
    options << (rounded_number / 2).round if (rounded_number / 2).between?(10_000, 99_999)

    # Ensure options are unique and shuffle them
    options.uniq!
    options.shuffle!

    # Guarantee the correct answer is among the options
    options << rounded_number unless options.include?(rounded_number)
    options.shuffle!

    # Select a random subject and context
    subjects = ["people", "spectators", "students", "fans", "participants"]
    activities = ["attended a football match", "joined a seminar", "watched a concert", "participated in an event", "visited the museum"]
    subject = subjects.sample
    activity = activities.sample

    # Format the question
    question = "#{number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse} #{subject} #{activity}. What is this number rounded to the nearest thousand?"

    # Format the answers
    answer_choices = ("A".."E").zip(options).map { |label, value| "#{label}. #{value.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}" }
    correct_answer = ("A".."E").to_a[options.index(rounded_number)]

    # Output the question, answer choices, and correct answer
    {
      question: question,
      answers: answer_choices,
      correct_answer: correct_answer
    }

    # Generate and display a question
    question_data = generate_question



  end
end
