# reload! &&  Questions::Generate::Maths::SequenceProgressionJob.perform_now(10)
class Questions::Generate::Maths::SequenceProgressionJob < ApplicationJob
  queue_as :default

  def perform(questions_to_generate = 50)
    @questions_to_generate = questions_to_generate
    questions = generate_questions
  end

  # Function to generate arithmetic sequences
  def generate_arithmetic_sequence
    start = rand(1..10)
    step = rand(2..5)
    terms = Array.new(6) { |i| start + step * i }
    {question: terms[0..-3] + ["___", "___"], answer: terms[-2..]}
  end

  # Function to generate geometric sequences
  def generate_geometric_sequence
    start = rand(1..5)
    ratio = rand(2..3)
    terms = Array.new(6) { |i| start * (ratio**i) }
    {question: terms[0..-3] + ["___", "___"], answer: terms[-2..]}
  end

  # Function to generate sequences with incremental differences
  def generate_incremental_sequence
    start = rand(1..5)
    increments = Array.new(5) { rand(1..5) }
    terms = [start]
    increments.each { |inc| terms << terms.last + inc }
    {question: terms[0..-3] + ["___", "___"], answer: terms[-2..]}
  end

  # Function to generate fraction sequences
  def generate_fraction_sequence
    num_start = rand(1..3)
    den_start = rand(3..7)
    num_step = 2
    den_increment = 3
    sequence = []
    numerator = num_start
    denominator = den_start

    6.times do
      sequence << "#{numerator}/#{denominator}"
      numerator += num_step
      denominator += den_increment
      den_increment += 2
    end

    {question: sequence[0..-3] + ["___", "___"], answer: sequence[-2..]}
  end

  # Generate multiple types of sequences dynamically
  def generate_questions
    questions = []

    # Generate 2 arithmetic sequences
    @questions_to_generate.times { questions << generate_arithmetic_sequence }

    # Generate 2 geometric sequences
    @questions_to_generate.times { questions << generate_geometric_sequence }

    # Generate 2 incremental sequences
    @questions_to_generate.times { questions << generate_incremental_sequence }

    # Generate 2 fraction sequences
    # @questions_to_generate.times { questions << generate_fraction_sequence }

    questions
  end
end
