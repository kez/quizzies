# Questions::Generate::English::GenerateCommonlyConfusedWordsJob.perform_now
class Questions::Generate::English::GenerateCommonlyConfusedWordsJob < ApplicationJob
  def perform(args = nil)
    questions = []

    words.each do |words_array|
      word = words_array.first

      puts "Running #{word}"
      data_string = Rails.cache.fetch("english:confused_words:#{word}") do
        response = call_api(word)
        parsed_data = JSON.parse(response.read_body)
        parsed_data.dig("choices", 0, "message", "content")
      end
      data = JSON.parse(data_string)
      question = {
        answer: word,
        question: data["question"].gsub(word, "________"),
        data: {options: words_array, definition: data["definition"]}
      }
      pp question
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

  def words
    @words ||= [["accept", "except"],
      ["adapt", "adept", "adopt"],
      ["adverse", "averse"],
      ["advice", "advise"],
      ["affect", "effect"],
      ["aid", "aide"],
      ["airs", "heirs"],
      ["altar", "alter"],
      ["all right", "alright"],
      ["all together", "altogether"],
      ["all ways", "always"],
      ["allude", "elude"],
      ["allusion", "illusion"],
      ["aloud", "allowed"],
      ["alternately", "alternatively"],
      ["amiable", "amicable"],
      ["among", "between"],
      ["amoral", "immoral"],
      ["amount", "number"],
      ["any one", "anyone"],
      ["appraise", "apprise"],
      ["as", "like"],
      ["ascent", "assent"],
      ["assure", "ensure", "insure"],
      ["bad", "badly"],
      ["bazaar", "bizarre"],
      ["belief", "believe"],
      ["berth", "birth"],
      ["beside", "besides"],
      ["blonde", "blond"],
      ["born", "borne"],
      ["borrow", "lend", "loan"],
      ["brake", "break"],
      ["breach", "breech"],
      ["breath", "breathe"],
      ["bridal", "bridle"],
      ["broach", "brooch"],
      ["by", "buy", "bye"],
      ["canvas", "canvass"],
      ["cereal", "serial"],
      ["censor", "sensor", "censure"],
      ["chord", "cord"],
      ["cite", "site", "sight"],
      ["climactic", "climatic"],
      ["coarse", "course"],
      ["complement", "compliment"],
      ["conform", "confirm"],
      ["congenial", "congenital"],
      ["conscience", "conscious"],
      ["continual", "continuous"],
      ["corps", "corpse"],
      ["council", "counsel"],
      ["creak", "creek"],
      ["credible", "creditable"],
      ["criteria", "criterion"],
      ["curb", "kerb"],
      ["currant", "current"],
      ["dairy", "diary"],
      ["defuse", "diffuse"],
      ["draught", "draft"],
      ["desert", "dessert"],
      ["device", "devise"],
      ["discreet", "discrete"],
      ["disinterested", "uninterested"],
      ["dual", "duel"],
      ["each", "every"],
      ["elicit", "illicit"],
      ["emigrant", "immigrant"],
      ["eminent", "imminent"],
      ["ensure", "insure"],
      ["envelop", "envelope"],
      ["explicit", "implicit"],
      ["fair", "fare"],
      ["farther", "further"],
      ["fawn", "faun"],
      ["fewer", "less"],
      ["forbear", "forebear"],
      ["foreword", "forward"],
      ["forth", "fourth"],
      ["found", "founded"],
      ["freeze", "frieze"],
      ["fun", "funny"],
      ["gorilla", "guerrilla"],
      ["grisly", "grizzly"],
      ["heroin", "heroine"],
      ["historic", "historical"],
      ["hoard", "horde"],
      ["interested", "interesting"],
      ["incredible", "incredulous"],
      ["intolerable", "intolerant"],
      ["its", "it's"],
      ["later", "latter"],
      ["lay", "lie"],
      ["lessen", "lesson"],
      ["lightening", "lightning"],
      ["loathe", "loath"],
      ["loose", "lose"],
      ["marital", "martial"],
      ["may be", "maybe"],
      ["peace", "piece"],
      ["peek", "pique", "peak"],
      ["peer", "pier"],
      ["perspective", "prospective"],
      ["plain", "plane"],
      ["practice", "practise"],
      ["prescribe", "proscribe"],
      ["precede", "proceed"],
      ["premise", "premises"],
      ["principal", "principle"],
      ["profit", "prophet"],
      ["quiet", "quite"],
      ["quote", "quotation"],
      ["rain", "reign", "rein"],
      ["real", "really", "reality", "realty"],
      ["receipt", "recipe"],
      ["regimen", "regiment"],
      ["respectable", "respectful", "respective", "respectfully", "respectively"],
      ["retch", "wretch"],
      ["rifle", "riffle"],
      ["rise", "raise", "arise"],
      ["sale", "sell"],
      ["seam", "seem"],
      ["sensual", "sensuous", "sensible"],
      ["sever", "severe"],
      ["shear", "sheer"],
      ["stationary", "stationery"],
      ["storey", "story"],
      ["straight", "strait"],
      ["than", "then"],
      ["their", "there", "they're"],
      ["titillate", "titivate"],
      ["tortuous", "torturous"],
      ["vicious", "viscous"],
      ["waist", "waste"],
      ["wary", "weary"],
      ["wave", "waive"],
      ["weak", "week"],
      ["wear", "ware"],
      ["were", "we're"],
      ["weather", "whether"],
      ["wet", "whet"],
      ["which", "witch"],
      ["who's", "whose"],
      ["wreath", "wreathe"],
      ["wont", "won't"],
      ["your", "you're"]]
  end
end
