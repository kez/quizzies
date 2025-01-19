# reload! &&  Questions::Generate::English::GenerateFocussedVocabularyJob.perform_now
class Questions::Generate::English::GenerateFocussedVocabularyJob < ApplicationJob
  def perform(args = nil)
    words_file = "data/english/british_english_vocabulary_focussed.txt"

    @words = File.readlines(words_file).map(&:strip)
    questions = []

    runs = 3
    run = 1

    while run <= runs
      @words.each do |word|
        puts "Running run #{run} #{word}"

        data_string = Rails.cache.fetch("english:vocabulary_focussed:#{word}:#{run}") do
          response = call_api(word)
          parsed_data = JSON.parse(response.read_body)
          parsed_data.dig("choices", 0, "message", "content")
        end
        data = JSON.parse(data_string)

        questions << {
          answer: data["definition"],
          question: data["statement"],
          data: {options: [data["definition"], data["possible_answers"][0], data["possible_answers"][1], data["possible_answers"][2]], definition: data["definition"], word: word}
        }
      end
      run += 1
    end
    questions
  end

  private

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
            Return a json object with 3 entries.
            
            statement: a short child friendly sentence including the word "#{word}"
            definition: a short definition of the word "#{word}"
            possible_answers: an array of 3 other false definitions of the word "#{word}"
            
            You should return a valid JSON object with the given keys.
            Do not include the word in the definition, just give the definition
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
