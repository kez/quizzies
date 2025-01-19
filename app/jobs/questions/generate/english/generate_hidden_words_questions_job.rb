# Questions::Generate::English::GenerateHiddenWordsQuestionsJob.perform_now
class Questions::Generate::English::GenerateHiddenWordsQuestionsJob < ApplicationJob
  def perform(args = nil)
    questions = []

    words.each do |word|
      puts "Running #{word}"
      # next unless Rails.cache.read("english:hidden_words:#{word}")
      # data_string = Rails.cache.fetch("english:hidden_words:#{word}") do
      response = call_api(word)
      # pp response.read_body
      parsed_data = JSON.parse(response.read_body)
      data_string = parsed_data.dig("choices", 0, "message", "content")
      # end
      # pp data_string
      data = JSON.parse(data_string)

      pp data
      # questions << {
      #   answer: word,
      #   question: data["question"],
      #   data: {options: [data["possible_answer_1"], data["possible_answer_2"], data["possible_answer_3"], data["possible_answer_4"]], definition: data["definition"]}
      # }
      # break if questions.size > 100
    end
    questions
  end

  private

  def words
    @words ||= %w[teas
      meal
      chap
      atom
      skin
      apes
      mesh
      pear
      scab
      inch
      full
      help
      love
      mend
      vest
      drag
      tram
      fort].sort
  end

  require "net/http"
  def call_api(word)
    uri = URI("https://api.openai.com/v1/chat/completions")
    # HTTP request body
    body = {
      model: "gpt-4o",

      response_format: {type: "json_object"},
      messages: [
        # {
        #   role: "developer",
        #   content: "The words here are the only other words you may use as a possible alternatives: `#{@words.join(", ")}`"
        # },
        {
          role: "user",
          content: <<~PROMPT
            Generate 5 sentences.  The sentences must be british English.  The sentence must contain two consecutive words. The consecutive words must not be nouns or names.  The consecutive words must be more than 2 letters.  The first of these words must end in "#{word[0..1]}" and the next word must start with "#{word[2..3]}".  Alternatively the first word can end "#{word[0]}" and the next word can start with "#{word[1..3]}".  Output the sentence, the the two words.  Also output "#{word}" as the hidden word.  Output in a json array of objects
          PROMPT
        }
      ], 
      max_tokens: 100
    }.to_json
    # HTTP request headers
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV["OPENAI_API_KEY"]}" # Replace with your API key
    }
    # Create and send the HTTP request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri, headers)
    request.body = body

    response = http.request(request)
  end
end
