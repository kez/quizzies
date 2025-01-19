# reload! &&  Questions::Generate::Maths::GenerateFractionEquivalenceQuestionsJob.perform_now(100)
class Questions::Generate::Maths::GenerateFractionEquivalenceQuestionsJob < ApplicationJob
  queue_as :default
  include ApplicationHelper
  def perform(questions_to_generate = 1000)
    @dir = "storage/fractions"
    FileUtils.mkdir_p(@dir)
    questions = []
    generated = generate_quiz(count: questions_to_generate)
    generated.each do |question|
      questions << {
        question: question[:question].join("/"),
        answer: question[:options][question[:correct]].join("/"),
        data: {options: question[:options].map { |option| option.join("/") }, correct: question[:options][question[:correct]].join("/")}
      }

      question[:question].each_with_index do |num, idx|
        generate_fraction_image(num, question[:question][1], File.join(@dir, "#{num}_#{question[:question][1]}.png"))
      end

      question[:options].each_with_index do |num, idx|
        generate_fraction_image(num.first, num.last, File.join(@dir, "#{num.first}_#{num.last}.png"))
      end
    end
    questions
  end

  private

  # Computes the greatest common divisor of two numbers
  def gcd(a, b)
    (b == 0) ? a : gcd(b, a % b)
  end

  # Returns a fraction in lowest terms
  def simplify_fraction(numerator, denominator)
    divisor = gcd(numerator, denominator)
    [numerator / divisor, denominator / divisor]
  end

  def generate_fraction_equivalence_question
    numerator = 0
    denominator = 0

    # Keep generating until we find a fraction with gcd > 1 and numerator < denominator
    loop do
      numerator = rand(1..9)
      denominator = rand(numerator + 1..20)  # ensures denominator is larger than numerator
      break if gcd(numerator, denominator) > 1
    end

    # Compute the correct (simplified) fraction
    correct_fraction = simplify_fraction(numerator, denominator)

    # Generate three incorrect fractions
    # Only add if the incorrect fraction's simplified form is different from the correct one
    incorrect_fractions = []
    while incorrect_fractions.size < 3
      n = rand(1..9)
      d = rand(n + 1..20)
      next if d == 0
      trial_simplified = simplify_fraction(n, d)
      incorrect_fractions << trial_simplified if trial_simplified != correct_fraction
    end

    # Shuffle the correct answer among the incorrect ones
    options = ([correct_fraction] + incorrect_fractions).shuffle
    correct_index = options.index(correct_fraction)

    {
      question: [numerator, denominator],
      options: options,
      correct: correct_index
    }
  end

  def generate_quiz(count: 5)
    (1..count).map { generate_fraction_equivalence_question }
  end

  def generate_fraction_image(numerator, denominator, output_file)
    return if File.exist?(output_file)
    # Create an image with white background

    # Draw the numerator
    numerator_text = Vips::Image.text(numerator.to_s, dpi: 300)
    numerator_text = numerator_text.gravity("centre", 100, 50)

    # Draw the denominator
    denominator_text = Vips::Image.text(denominator.to_s, dpi: 300)
    denominator_text = denominator_text.gravity("centre", 100, 50)

    # Draw the line
    line = Vips::Image.black(100, 2).invert
    line = line.gravity("centre", 100, 2)

    # Combine the images
    fraction_image = numerator_text.join(line, :vertical)
    fraction_image = fraction_image.join(denominator_text, :vertical).invert

    # Save the image to a file
    fraction_image.write_to_file(output_file)
  end

  # Example usage
end
