# reload! &&  Questions::SeedQuestionsJob.perform_now
class Questions::SeedQuestionsJob < ApplicationJob
  queue_as :default

  def perform(args = nil)
    # loop each job in generate/maths folder and execute it
    files = Dir.glob(Rails.root.join("app", "jobs", "questions", "generate", "**", "*.rb"))
    files.each do |file|
      topic = file.split("/")[-2]
      job_name = File.basename(file, ".rb").camelize
      question_type = File.basename(file, ".rb").gsub("generate_", "").gsub("_job", "").gsub("_questions", "")

      # next unless %w[sequence_progression].include?(question_type)
      # next unless %w[multiplication_division ratio best_missing_words antonyms homophones commonly_confused_words ie_ei_words commonly_misspelled_words word_ladders].include?(question_type)
      # next unless %w[place_values].include?(question_type)
      next unless %w[place_value_multiplication_division place_values word_ladders fraction_equivalence spellings difficult_spellings].include?(question_type)
      next unless %w[difficult_spellings].include?(question_type)
      # next unless %w[idioms homophones antonyms].include?(question_type)
      # next unless %w[spellings].include?(question_type)
      # next unless %w[best_missing_words].include?(question_type)

      job_class = "Questions::Generate::#{topic.camelize}::#{job_name}".constantize
      puts question_type
      topic = Topic.find_by(key: question_type)
      number_to_create = 20

      if %w[multiplication_division homophones antonyms word_ladders fraction_equivalence].include?(question_type)
        number_to_create = 100
      end

      if %w[commonly_confused_words ie_ei_words commonly_misspelled_words word_ladders place_values place_value_multiplication_division spellings difficult_spellings].include?(question_type)
        number_to_create = 1000
      end

      klass = job_class.new(number_to_create)

      questions = klass.perform_now

      pp question_type

      questions.each do |question|
        h = {topic: topic,
             title: question[:question]}

        if question[:answer].is_a?(Array)
          h[:answers] = question[:answer]
        else
          h[:answer] = question[:answer]
        end

        h[:data] = question[:data] if question[:data]

        # pp h
        begin
          Question.create!(h)
        rescue SQLite3::ConstraintException => e
          # raise e
        rescue ActiveRecord::RecordNotUnique => e
          # raise e
        end
      end
    end
  end
end
