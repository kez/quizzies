# reload! &&  Questions::Generate::Maths::GeneratePlaceValuesJob.perform_now(10)
class Questions::Generate::Maths::GeneratePlaceValuesJob < ApplicationJob
  queue_as :default
  include ActionView::Helpers::NumberHelper
  def perform(questions_to_generate = 50)
    questions = []

    words_file = "data/maths/place_value_questions.json"

    data = JSON.parse(File.read(words_file)).shuffle

    questions_to_generate.times do
      item = data.sample
      questions << {
        question: "What is the value of the #{item["place_value_digit"]} in the number #{number_with_delimiter((item["main_number"]), delimiter: ",")}?",
        answer: item["correct_answer"],
        data: {options: item["options"].map { |x| number_with_delimiter(x, delimiter: ",") }, main_number: item["main_number"], place_value_digit: item["place_value_digit"]}

      }
    end

    questions
  end

  private

  #
end
