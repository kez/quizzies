# reload! && Questions::Generate::English::GenerateDifficultSpellingsJob.perform_now
class Questions::Generate::English::GenerateDifficultSpellingsJob < ApplicationJob
  def perform(args = nil)
    questions = []

    runs = 5
    run = 1
    while run <= runs
      words.each do |words_array|
        word = words_array.first
        word_with_typo = words_array.second

        puts "Running Run #{run} for  #{word}"
        data_string = Rails.cache.fetch("english:difficult_spellings:runs:#{word}:#{run}") do
          response = call_api(word)
          parsed_data = JSON.parse(response.read_body)
          # pp parsed_data

          data_string = parsed_data.dig("choices", 0, "message", "content")
        end

        data = JSON.parse(data_string)
        question = {
          answer: word,
          question: data["question"].gsub(word, word_with_typo),
          data: {definition: data["definition"]}
        }
        questions << question
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
        {
          role: "user",
          content: <<~PROMPT
            Return a JSON object with the following 2 entries:
            
            question : A short child friendly statement in british english that includes the word "#{word}" - the sentence MUST include this word.  The statement must not be a question.  The sentence must include the word "#{word}" only once.
            definition: best, short, dictionary definition of the word #{word}
            You should return a valid JSON object with the given keys.
          PROMPT
        }
      ]
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

  def words
    [
      ["completely", "completly"],
      ["conscious", "concious"],
      ["curiosity", "curiousity"],
      ["disappear", "dissapear"],
      ["familiar", "familar"],
      ["happened", "happend"],
      ["independent", "independant"],
      ["interrupt", "interupt"],
      ["knowledge", "knowlege"],
      ["necessary", "neccessary"],
      ["noticeable", "noticable"],
      ["occurrence", "occurance"],
      ["separate", "seperate"],
      ["surprise", "suprise"],
      ["truly", "truely"],
      %w[embarrassed embarassed],
      %w[firey fiery],
      %w[foreign forein],
      %w[existence existance],
      %w[exceed exede],
      %w[guarantee garantee],
      %w[harass harrass],
      %w[hierarchy hiararchy],
      %w[ignorance ignarence],
      %w[guage gage]

    ]
  end
end
