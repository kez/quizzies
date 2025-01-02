# Questions::Generate::English::GenerateBestMissingWordsJob.perform_now
class Questions::Generate::English::GenerateBestMissingWordsJob < ApplicationJob
  def perform(args = nil)
    words_file = "data/english/british_english_vocabulary.json"

    @words = JSON.parse(File.read(words_file)).shuffle
    questions = []

    @words.each do |word|
      puts "Running #{word}"
      data_string = Rails.cache.fetch("english:missing_words:#{word}") do
        response = call_api(word)
        parsed_data = JSON.parse(response.read_body)
        parsed_data.dig("choices", 0, "message", "content")
      end

      data = JSON.parse(data_string)

      questions << {
        answer: word,
        question: data["question"],
        data: {options: [data["possible_answer_1"], data["possible_answer_2"], data["possible_answer_3"]], definition: data["definition"]}
      }

      break if questions.size > 100
    end

    questions
  end

  private

  require "net/http"
  require "json"

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
            Return a JSON object with the following 3 entries:
            
            question : A short child friendly statement in british english that includes the word "#{word}" - the sentence MUST include this word.  The statement must not be a question.
            possible_answer_1: A different word but not too similar to the word `#{word}`
            possible_answer_2: Another, but different, possible alternative word but not too similar to the word `#{word}`
            possible_answer_3: #{word}
            definition: best, short, dictionary definition of the word #{word}

            You should return a valid JSON object with the given keys.
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
