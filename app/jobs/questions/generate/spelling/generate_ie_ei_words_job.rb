# Questions::Generate::Spelling::GenerateIeEiWordsJob.perform_now
class Questions::Generate::Spelling::GenerateIeEiWordsJob < ApplicationJob
  def perform(args = nil)
    questions = []

    words.each_with_index do |word, idx|
      puts "Running #{word}"
      data_string = Rails.cache.fetch("english:ieei:#{word}") do
        response = call_api(word)
        parsed_data = JSON.parse(response.read_body)
        parsed_data.dig("choices", 0, "message", "content")
      end
      data = JSON.parse(data_string)
      question = data["question"].gsub(word, "{word}")

      if word.include?("ie")
        answers = %w[i e]
        question = question.gsub("{word}", word.gsub("ie", "__"))
      elsif word.include?("ei")
        answers = %w[e i]
        question = question.gsub("{word}", word.gsub("ei", "__"))
      end

      question = {
        answer: answers,
        question: question,
        data: {definition: data["definition"], word:}
      }

      questions << question
    end

    questions
  end

  private

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
            question : A short child friendly statement in british english that includes the word "#{word}" - the sentence MUST include this word.
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
    http.request(request)
  end

  def words
    @words ||= [
      "achieve",
      "beige",
      "believe",
      "brief",
      "ceiling",
      "chief",
      "counterfeit",
      "deceive",
      "efficient",
      # "eider",
      "eight",
      "feint",
      "field",
      "financier",
      "foreign",
      "friend",
      "grief",
      "height",
      "heinous",
      "heir",
      "leisure",
      "mischief",
      "neighbour",
      "niece",
      "perceive",
      "piece",
      "pier",
      "priest",
      "receipt",
      "receive",
      "reign",
      "relief",
      "reprieve",
      "retrieved",
      "seize",
      "shield",
      "shriek",
      "siege",
      "sleigh",
      "societies", # @ todo fix
      "species",
      "species",
      "sufficient",
      "thief",
      "tier",
      "varieties",  # @ todo fix
      "vein",
      "weigh",
      "weight",
      "yield"

    ]
  end
end
