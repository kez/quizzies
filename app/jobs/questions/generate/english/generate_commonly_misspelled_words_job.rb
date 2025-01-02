# Questions::Generate::English::GenerateCommonlyMisspelledWordsJob.perform_now
class Questions::Generate::English::GenerateCommonlyMisspelledWordsJob < ApplicationJob
  def perform(args = nil)
    questions = []

    words.each do |words_array|
      word = words_array.first

      puts "Running #{word}"
      data_string = Rails.cache.fetch("english:misspelled_words:#{word}") do
        response = call_api(word)
        parsed_data = JSON.parse(response.read_body)
        parsed_data.dig("choices", 0, "message", "content")
      end
      data = JSON.parse(data_string)
      question = {
        answer: word,
        question: data["question"].gsub(word, "________"),
        data: {options: words_array[0..1], definition: data["definition"]}
      }
      questions << question
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
            
            question : A short child friendly statement in british english that includes the word "#{word}" - the sentence MUST include this word.  The statement must not be a question.
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
    @words ||= [
      ["acceptable", "acceptible", 0.2],
      ["accidentally", "accidently", 0.6],
      ["accommodate", "accomodate", 0.8],
      ["acquire", "aquire", 0.4],
      ["acquit", "aquite", 0.2],
      ["a lot", "alot", 0.9],
      ["amateur", "amatuer", 0.7],
      ["apparent", "aparent", 0.4],
      ["argument", "arguement", 0.5],
      ["atheist", "athiest", 0.7],
      ["believe", "beleive", 0.5],
      ["calendar", "calender", 0.6],
      ["category", "catagory", 0.4],
      ["cemetery", "cemetry", 0.7],
      ["changeable", "changable", 0.5],
      ["collectible", "collectable", 0.3],
      ["committed", "commited", 0.6],
      ["conscience", "consciense", 0.8],
      ["conscientious", "consciencious", 0.7],
      ["conscious", "concious", 0.6],
      ["definite", "definate", 0.8],
      ["definitely", "definately", 0.9],
      ["disappear", "dissapear", 0.7],
      ["discipline", "disipline", 0.5],
      ["drunkenness", "drunkeness", 0.8],
      ["embarrass", "embarass", 0.9],
      ["equipment", "equiptment", 0.5],
      ["exceed", "excede", 0.4],
      ["exhilarate", "exilarate", 0.8],
      ["existence", "existance", 0.7],
      ["fiery", "firey", 0.2],
      ["foreign", "foriegn", 0.8],
      ["fourth", "forth", 0.3],
      ["gauge", "guage", 0.8],
      ["generally", "generalley", 0.2],
      ["grammar", "grammer", 0.7],
      ["grateful", "greatful", 0.8],
      ["harass", "harrass", 0.7],
      ["height", "heigth", 0.6],
      ["hierarchy", "heirarchy", 0.5],
      ["ignorance", "ignorence", 0.4],
      ["immediate", "immediat", 0.4],
      ["independent", "independant", 0.9],
      ["indispensable", "indispensible", 0.6],
      ["judgement", "judgment", 0.2],
      ["knowledge", "knowlege", 0.5],
      ["leisure", "liesure", 0.5],
      ["lightning", "lightening", 0.6],
      ["maintenance", "maintainance", 0.8],
      ["manoeuvre", "maneuvre", 0.7],
      ["memento", "momento", 0.5],
      ["millennium", "millenium", 0.7],
      ["miniature", "miniture", 0.5],
      ["mischievous", "mischievious", 0.8],
      ["noticeable", "noticable", 0.8],
      ["occasion", "ocassion", 0.7],
      ["occasionally", "occassionally", 0.8],
      ["occurred", "occured", 0.7],
      ["occurrence", "ocurrence", 0.7],
      ["official", "offical", 0.5],
      ["parallel", "paralell", 0.6],
      ["parliament", "parlament", 0.6],
      ["pastime", "pasttime", 0.4],
      ["pigeon", "pidgeon", 0.8],
      ["possession", "posession", 0.7],
      ["preferable", "preferrable", 0.5],
      ["principal", "principle", 0.3],
      ["principle", "principal", 0.3],
      ["privilege", "priviledge", 0.8],
      ["questionnaire", "questionaire", 0.8],
      ["receive", "recieve", 0.9],
      ["recommend", "recomend", 0.7],
      ["reference", "referance", 0.7],
      ["referred", "refered", 0.7],
      ["relevant", "revelant", 0.6],
      ["religious", "religous", 0.7],
      ["restaurant", "restraunt", 0.9],
      ["rhythm", "rythm", 0.8],
      ["ridiculous", "rediculous", 0.9],
      ["sandal", "sandell", 0.3],
      ["schedule", "schedual", 0.5],
      ["scissors", "scisors", 0.6],
      ["sensible", "sensable", 0.6],
      ["separate", "seperate", 0.9],
      ["special", "speical", 0.4],
      ["their", "thier", 0.8],
      ["there", "ther", 0.3],
      ["they're", "there", 0.3],
      ["to", "too", 0.4],
      ["tomorrow", "tommorow", 0.9],
      ["too", "to", 0.4],
      ["twelfth", "twelvth", 0.7],
      ["two", "to", 0.3],
      ["tyranny", "tyrany", 0.8],
      ["until", "untill", 0.7],
      ["vicious", "viscious", 0.7],
      ["weather", "wether", 0.8],
      ["weird", "wierd", 0.9],
      ["you're", "your", 0.6],
      ["your", "you're", 0.6]
    ]
  end
end
