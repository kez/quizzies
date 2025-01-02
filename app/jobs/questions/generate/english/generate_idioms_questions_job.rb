# Questions::Generate::English::GenerateIdiomsQuestionsJob.perform_now
class Questions::Generate::English::GenerateIdiomsQuestionsJob < ApplicationJob
  queue_as :default

  require "net/http"

  def perform(questions_to_generate = 10)
    questions = []
    idioms.each do |idiom|
      input = idiom[:idiom].to_s.downcase
      meaning = idiom[:meaning]
      next if idiom.values.join.include?(" sb")
      puts "+++++++++++++++++++++++++++++++++++++++"
      sentence = Rails.cache.fetch("idiom:sentence:#{input}") do
        generate_sentence_with_idiom(input)
      end

      puts "+++++++++++++++++++++++++++++++++++++++"

      json_string = sentence.to_s.split("```json")&.last&.split("```")&.first
      next unless json_string
      puts "###################"
      puts json_string
      json = JSON.parse(json_string)
      puts json
      puts "###################"

      questions << {
        question: json_string,
        answer: input.to_s.downcase
      }
      break if questions.size >= questions_to_generate
    end

    questions
  end

  private

  # Method to request a sentence with the given idiom
  def generate_sentence_with_idiom(idiom)
    uri = URI("https://api.openai.com/v1/chat/completions")

    # HTTP request body
    body = {
      model: "gpt-4o",
      messages: [
        {
          role: "user",
          content: <<~PROMPT
            Generate a JSON array of 3 sentences.  Ensure all sentences use british english.
            1. A child-friendly sentence that uses the British English idiom "#{idiom}."
            2. A child-friendly sentence similar to the first but does not include the idiom.
            3. Another child-friendly sentence similar to the first but does not include the idiom.
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

    # Parse and display the response
    if response.code == "200"
      result = JSON.parse(response.body)
      if result["choices"] && result["choices"].any?
        sentence = result["choices"][0]["message"]["content"]
        pp sentence
        sentence.strip
      else
        puts "No sentence generated. Please try again."
      end
    else
      puts "Error: #{response.code} - #{response.message}"
      puts response.body
    end
  end

  def idioms
    @idioms = [

      {idiom: "A bear with a sore head", meaning: "an irritable person"},
      {idiom: "A bit of a dark horse", meaning: "person with hidden abilities"},
      {idiom: "A bitter pill to swallow", meaning: "a difficult fact to accept"},
      {idiom: "A brainwave", meaning: "sudden clear idea"},
      {idiom: "A bull in a china shop", meaning: "a very clumsy person"},
      {idiom: "A cat in hell's chance", meaning: "no chance at all"},
      {idiom: "A close shave", meaning: "a narrow escape"},
      {idiom: "A different kettle of fish", meaning: "a totally different situation"},
      {idiom: "A dog's breakfast/dinner", meaning: "a mess"},
      {idiom: "A dog's life", meaning: "a difficult, hard life"},
      {idiom: "A fish out of water", meaning: "person who feels uncomfortable in unfamiliar surroundings"},
      {idiom: "A memory like a sieve", meaning: "a poor memory"},
      {idiom: "A night owl", meaning: "person who enjoys staying up late"},
      {idiom: "Above board", meaning: "honest"},
      {idiom: "Against all odds", meaning: "despite the difficulties"},
      {idiom: "All along", meaning: "from the beginning"},
      {idiom: "All but", meaning: "nearly, almost"},
      {idiom: "All in", meaning: "exhausted"},
      {idiom: "All in all", meaning: "when everything is considered"},
      {idiom: "All the same", meaning: "yet, however"},
      {idiom: "An old wives' tale", meaning: "false belief"},
      {idiom: "A pain in the neck", meaning: "annoying thing"},
      {idiom: "A piece of cake", meaning: "sth very easy to do"},
      {idiom: "A red-letter day", meaning: "a very important day"},
      {idiom: "A red rag to a bull", meaning: "action liable to provoke sb"},
      {idiom: "A sitting duck", meaning: "an easy target"},
      {idiom: "As busy as a bee/ a busy bee", meaning: "very busy"},
      {idiom: "As a last resort", meaning: "when all else has failed"},
      {idiom: "As the crow flies", meaning: "in a direct line"},
      {idiom: "At large", meaning: "free, not caught"},
      {idiom: "A wild-goose chase", meaning: "a hopeless search"},
      {idiom: "Bark up the wrong tree", meaning: "to make a mistake"},
      {idiom: "Be all at sea", meaning: "to be in a state of confusion"},
      {idiom: "Be all fingers and thumbs", meaning: "to be awkward, clumsy"},
      {idiom: "Be born yesterday", meaning: "a long time ago"},
      {idiom: "Be broke", meaning: "to have no money at all"},
      {idiom: "Be dying for sth", meaning: "to really want sth"},
      {idiom: "Be fit for", meaning: "to be good enough for"},
      {idiom: "Be flat out", meaning: "to be very tired"},
      {idiom: "Be full of beans", meaning: "to be very lively"},
      {idiom: "Be green", meaning: "not be very experienced"},
      {idiom: "Soaked to the skin", meaning: "to be very wet"},
      {idiom: "Be in black", meaning: "to be out of debt"},
      {idiom: "Be in pink", meaning: "to be healthy"},
      {idiom: "Be in a quandary", meaning: "to be confused"},
      {idiom: "Be the apple of sb's eye", meaning: "to be very precious to sb"},
      {idiom: "Be in the doghouse", meaning: "to be out of favour, in trouble"},
      {idiom: "Be in the sb's shoes", meaning: "to be in sb's position"},
      {idiom: "Be in the black books", meaning: "not very popular"},
      {idiom: "Be in the know", meaning: "to be well-informed"},
      {idiom: "Be in the same boat", meaning: "to be in the same situation"},
      {idiom: "Be in two minds about sth", meaning: "not to know which of the two things to do"},
      {idiom: "Be all very well", meaning: "to appear satisfactory but in fact not be"},
      {idiom: "Be up in arms", meaning: "to be very angry"},
      {idiom: "Beat about the bush", meaning: "to avoid saying what one means directly"},
      {idiom: "Beat sb black and blue", meaning: "to hit sb repeatedly until bruised"},
      {idiom: "Behind bars", meaning: "in prison"},
      {idiom: "Behind the scenes", meaning: "in secret"},
      {idiom: "Be on the cards", meaning: "to be likely to happen"},
      {idiom: "Be on the up and up", meaning: "to improve steadily"},
      {idiom: "Be over the moon", meaning: "to be elated"},
      {idiom: "Be second to none", meaning: "to be as good as the best"},
      {idiom: "Be sound asleep", meaning: "to sleep heavily"},
      {idiom: "Be the perfect image of sb", meaning: "to look exactly like sb"},
      {idiom: "Be thick", meaning: "to be stupid"},
      {idiom: "Big headed", meaning: "conceited, boastful"},
      {idiom: "Blue-eyed boy", meaning: "favourite"},
      {idiom: "Bolt from the blue", meaning: "suddenly"},
      {idiom: "Break even", meaning: "to show neither loss nor profit"},
      {idiom: "Break the ice", meaning: "to ease the tension when one first meets people"},
      {idiom: "Browned off", meaning: "fed up, bored"},
      {idiom: "Burry one's head in the sand", meaning: "to avoid or ignore responsibility"},
      {idiom: "Butter the boss up", meaning: "to flatter sb"},
      {idiom: "By and large", meaning: "generally speaking"},
      {idiom: "By trial and error", meaning: "learning from one's mistakes"},
      {idiom: "Call it quits", meaning: "to give up, to stop"},
      {idiom: "Call names", meaning: "to insult"},
      {idiom: "Catch sb red-handed", meaning: "to be caught while committing a crime"},
      {idiom: "Chair a meeting", meaning: "to preside a meeting"},
      {idiom: "Cook one's goose", meaning: "to end one's plans abruptly"},
      {idiom: "Come out of one's shell", meaning: "to gain personal confidence"},
      {idiom: "Come to a head", meaning: "to reach a crisis"},
      {idiom: "Come to a standstill", meaning: "not to progress"},
      {idiom: "Come to terms with", meaning: "to accept a difficult"},
      {idiom: "Come to the point", meaning: "to reach the main point in a discussion"},
      {idiom: "Cost a bomb", meaning: "very expensive"},
      {idiom: "Crocodile tears", meaning: "false tears"},
      {idiom: "Cross one's mind", meaning: "to think of sth"},
      {idiom: "Cry over spilt milk", meaning: "to grieve over sth that can't be put right"},
      {idiom: "Cut sb dead", meaning: "to ignore sb"},
      {idiom: "Deal a blow to", meaning: "to damage one's hopes"},
      {idiom: "Different as chalk and cheese", meaning: "very different"},
      {idiom: "Dog eat dog", meaning: "ruthless competition, rivalry"},
      {idiom: "Donkey work", meaning: "boring, monotonous work"},
      {idiom: "Donkey's years", meaning: "a long time"},
      {idiom: "Don't hold your breath", meaning: "wait for sb anxiously"},
      {idiom: "Do time", meaning: "to serve a prison sentence"},
      {idiom: "Down in the dumps", meaning: "not cheerful"},
      {idiom: "Down the drain", meaning: "wasted, lost"},
      {idiom: "Drink like a fish", meaning: "to drink a lot of alcohol"},
      {idiom: "Drop a brick", meaning: "to say sth tactlessly"},
      {idiom: "Drop sb a line", meaning: "send sb a letter"},
      {idiom: "Eat one's heart out", meaning: "to feel jealous"},
      {idiom: "Every nook and cranny", meaning: "everywhere"},
      {idiom: "Fair and square", meaning: "within the rules"},
      {idiom: "Fall head over heels", meaning: "to fall in love quickly"},
      {idiom: "Fall into place", meaning: "to become clear"},
      {idiom: "Feek blue", meaning: "to be depressed"},
      {idiom: "Feel down in the mouth", meaning: "to feel discouragement or depression"},
      {idiom: "Feel in one's bones", meaning: "feeling sth instinctively"},
      {idiom: "Feel one's ears burning", meaning: "to be sure that sb is talking about you"},
      {idiom: "Fine kettle of fish", meaning: "confused state of affairs"},
      {idiom: "Flog a dead horse", meaning: "to waste time"},
      {idiom: "Fly off the handle", meaning: "to become very angry"},
      {idiom: "For all I care", meaning: "I don't care"},
      {idiom: "For all I know", meaning: "as far as I know"},
      {idiom: "For the time being", meaning: "temporarily"},
      {idiom: "Frosty welcome", meaning: "unfriendly reception"},
      {idiom: "Gatecrasher", meaning: "sb attending a party, event etc without an invitation"},
      {idiom: "Get a bit hot under the collar", meaning: "to get angry, upset or embarrassed"},
      {idiom: "Get a move on", meaning: "to hurry up"},
      {idiom: "Get cold feet", meaning: "to lose courage"},
      {idiom: "Get one's nerves", meaning: "to irritate or annoy sb"},
      {idiom: "Get a problem off one's chest", meaning: "to tell sb else about your problem"},
      {idiom: "Get off on the wrong foot", meaning: "to argue or disagree at the beginning of a relationship"},
      {idiom: "Get out of hand", meaning: "get out of control"},
      {idiom: "Get rid of sth", meaning: "to give sth away"},
      {idiom: "Get out of bed on the wrong side", meaning: "to be in a bad mood"},
      {idiom: "Get the sack", meaning: "to be dismissed from the job"},
      {idiom: "Get the wrong end of the stick", meaning: "to misunderstand"},
      {idiom: "Give way to", meaning: "to give in, yield"},
      {idiom: "Get your own back", meaning: "to get revenge"},
      {idiom: "Give and take", meaning: "to compromise"},
      {idiom: "Give sb the slip", meaning: "to escape from sb"},
      {idiom: "Give sb the cold shoulder", meaning: "to ignore sb"},
      {idiom: "Go for a song", meaning: "to be sold very cheaply"},
      {idiom: "Go without saying", meaning: "to be a foregone conclusion"},
      {idiom: "Golden opportunity", meaning: "the best chance"},
      {idiom: "Go to one's head", meaning: "to make conceited"},
      {idiom: "Go to the dogs", meaning: "to go to waste"},
      {idiom: "Grease sb's palm", meaning: "to bribe sb"},
      {idiom: "Grey matter", meaning: "the brains, intelligence"},
      {idiom: "Grow out of sth", meaning: "to become too big for sth"},
      {idiom: "Hand in glove with sb", meaning: "to be in very close contact with sb"},
      {idiom: "Have a bee in one's bonnet", meaning: "to have an obsession about sth"},
      {idiom: "Have a cheek", meaning: "to act rudely"},
      {idiom: "Have a frog in one's throat", meaning: "inability to speak due to nervousness"},
      {idiom: "Have a sharp tongue", meaning: "to tend to say unkind or hurtful things"},
      {idiom: "Have a job", meaning: "to find it difficult"},
      {idiom: "Have a yellow streak", meaning: "to be a coward"},
      {idiom: "Have an early night", meaning: "to go to bed early"},
      {idiom: "Have butterflies in one's stomach", meaning: "to be very nervous about sth"},
      {idiom: "Have kittens", meaning: "to be upset"},
      {idiom: "Have many irons in the fire", meaning: "to have a lot of plans in progress"},
      {idiom: "Have no option but", meaning: "must, have no choice"},
      {idiom: "Have one's heart in one's mouth", meaning: "to be extremely anxious"},
      {idiom: "Have time on one's hands", meaning: "to have free time"},
      {idiom: "Have the cheek", meaning: "to dare to complain"},
      {idiom: "Have the gift of the gab", meaning: "to be able to talk well, persuasively"},
      {idiom: "Have words with sb", meaning: "to have an argument"},
      {idiom: "Hear it through the grape-vine", meaning: "to find out information indirectly"},
      {idiom: "Hit the nail on the head", meaning: "to say exactly the right thing"},
      {idiom: "Hit the roof", meaning: "to get very angry"},
      {idiom: "Hit the sack", meaning: "to go to bed"},
      {idiom: "Hold one's horses", meaning: "to wait, be patient"},
      {idiom: "Hold water", meaning: "to be able to be proved true"},
      {idiom: "If I were in sb's shoes", meaning: "if I were sb"},
      {idiom: "Ill at ease", meaning: "embarrassed, uncomfortable"},
      {idiom: "In a flash", meaning: "very quickly"},
      {idiom: "In a nutshell", meaning: "briefly, in a few words"},
      {idiom: "In a rut", meaning: "to be fixed in a monotonous routine"},
      {idiom: "In a tick", meaning: "shortly, soon"},
      {idiom: "In black and white", meaning: "in writing, clear"},
      {idiom: "In cold blood", meaning: "done deliberately (of a murder)"},
      {idiom: "In deep water", meaning: "in difficulty"},
      {idiom: "In public", meaning: "in the presence of the other people"},
      {idiom: "In the air", meaning: "uncertain, spreading about"},
      {idiom: "In the long run", meaning: "after a long period of time"},
      {idiom: "In the nick of time", meaning: "just in time"},
      {idiom: "It's all Greek to me", meaning: "sth new or foreign, not easily understood"},
      {idiom: "Keep a straight face", meaning: "to manage to look serious"},
      {idiom: "Keep an eye on sth", meaning: "to guard sth"},
      {idiom: "Keep one's chin up", meaning: "not to be discouraged"},
      {idiom: "Keep one's fingers crossed", meaning: "to hope that sth will turn out well"},
      {idiom: "Keep oneself to oneself", meaning: "to live quietly, unsociably"},
      {idiom: "Keep sth quiet", meaning: "to keep sth secret"},
      {idiom: "Keep up with the Joneses", meaning: "to compete with others in material goods"},
      {idiom: "Kick the bucket", meaning: "to die"},
      {idiom: "Kill time", meaning: "to pass time while waiting for something"},
      {idiom: "Kill two birds with one stone", meaning: "to solve two problems with one single action"},
      {idiom: "Know the ropes", meaning: "to know all the details of a business"},
      {idiom: "Lay bare", meaning: "to make public"},
      {idiom: "Lend sb a hand", meaning: "to give help"},
      {idiom: "Let sleeping dogs lie", meaning: "to avoid mentioning a subject which could cause trouble"},
      {idiom: "Let the cat out the bag", meaning: "to reveal a secret"},
      {idiom: "Like cat and dog", meaning: "disagree violently"},
      {idiom: "Like water off a duck's back", meaning: "having no effect"},
      {idiom: "Live out of a suitcase", meaning: "to travel often"},
      {idiom: "Lose heart", meaning: "to become discouraged"},
      {idiom: "Lose one's head", meaning: "to lose self-control"},
      {idiom: "Lose one's nerve", meaning: "to back out because of fear"},
      {idiom: "Lost cause", meaning: "hopeless situation or case"},
      {idiom: "Make a flying visit", meaning: "to make a quick trip"},
      {idiom: "Make a fool of oneself", meaning: "to make oneself look stupid"},
      {idiom: "Make a killing", meaning: "to have a sudden, great success"},
      {idiom: "Make a name for oneself", meaning: "to become famous"},
      {idiom: "Make a mountain out of a molehill", meaning: "to cause a fuss about a trivial matter"},
      {idiom: "Make a pig of oneself", meaning: "to eat/drink to excess"},
      {idiom: "Make light of", meaning: "to treat sth as unimportant"},
      {idiom: "Earn a living", meaning: "to earn money"},
      {idiom: "Make hay while the sun shines", meaning: "to take advantage of favourable circumstances"},
      {idiom: "Make head or tail of", meaning: "to understand"},
      {idiom: "Make money hand over fist", meaning: "to make a lot of money quickly and easily"},
      {idiom: "Make one's blood boil", meaning: "to cause sb to become very angry"},
      {idiom: "Make one's getaway", meaning: "to escape"},
      {idiom: "Make sb's day", meaning: "to make sb very happy"},
      {idiom: "Meet behind closed doors", meaning: "to meet secretly"},
      {idiom: "Moon around", meaning: "to look miserable"},
      {idiom: "Little wonder", meaning: "not surprising"},
      {idiom: "No room to swing a cat", meaning: "no room at all"},
      {idiom: "Not be one's cup of tea", meaning: "not to suit one's mind"},
      {idiom: "Null and void", meaning: "invalid, not legally binding"},
      {idiom: "Off colour", meaning: "to look slightly unwell"},
      {idiom: "Off the cuff", meaning: "without preparation"},
      {idiom: "Off the point", meaning: "irrelevant"},
      {idiom: "Off the record", meaning: "unofficially"},
      {idiom: "One's flesh and blood", meaning: "family member"},
      {idiom: "On account of", meaning: "because of"},
      {idiom: "Once and for all", meaning: "for the last time"},
      {idiom: "Once in a blue moon", meaning: "very rarely"},
      {idiom: "On a shoe string", meaning: "on a very small budget"},
      {idiom: "On no account", meaning: "under no circumstances"},
      {idiom: "On second thought", meaning: "having changed one's mind"},
      {idiom: "On the air", meaning: "broadcasting"},
      {idiom: "On the dole", meaning: "receiving unemployment benefit"},
      {idiom: "On the spur of the moment", meaning: "without thinking about sth"},
      {idiom: "On the rack", meaning: "in a state of great anxiety"},
      {idiom: "Open to debate", meaning: "not decided/settled"},
      {idiom: "Out-and-out", meaning: "thorough, complete"},
      {idiom: "Out of the blue", meaning: "suddenly and unexpectedly"},
      {idiom: "Out of the frying pan into the fire", meaning: "from a difficult situation to a worse"},
      {idiom: "Out of the question", meaning: "impossible"},
      {idiom: "Out of turn", meaning: "not in the correct order/time"},
      {idiom: "Paint the town red", meaning: "to have a lovely time"},
      {idiom: "Part and parcel of", meaning: "basic part of"},
      {idiom: "Pay one's cards right", meaning: "to act cleverly"},
      {idiom: "Play cat and mouse with sb", meaning: "to keep sb in a state of uncertain expectation treating alternatively cruelly and kindly"},
      {idiom: "Play truant", meaning: "to stay away from school without good reason"},
      {idiom: "Plenty more fish in the sea", meaning: "many opportunities in life, for love etc"},
      {idiom: "Pop the question", meaning: "to make a proposal of marriage"},
      {idiom: "Pull a few strings", meaning: "to use influential friends in order to obtain an advantage"},
      {idiom: "Pull one's socks up", meaning: "to make a greater effort"},
      {idiom: "Pull one's leg", meaning: "to tease or trick"},
      {idiom: "Put one's foot down", meaning: "to insist"},
      {idiom: "Put one's foot in it", meaning: "to join or interrupt a conversation you are not a part of"},
      {idiom: "Put one's heart and soul into sth", meaning: "to be devoted to sth"},
      {idiom: "Put down roots", meaning: "to settle down"},
      {idiom: "Put sb's name forward", meaning: "to nominate"},
      {idiom: "Put the cat among the pigeons", meaning: "to cause trouble"},
      {idiom: "Put words into one's mouth", meaning: "to pretend that sb has said sth that he/she hasn't actually said"},
      {idiom: "Quick on the uptake", meaning: "quick to understand"},
      {idiom: "Rain cats and dogs", meaning: "to rain heavily"},
      {idiom: "Red tape", meaning: "unnecessary bureaucracy"},
      {idiom: "Ring a bell", meaning: "to remind sb of sth"},
      {idiom: "See the back of", meaning: "to be glad to see sb leave"},
      {idiom: "Looking through rose-coloured spectacles", meaning: "to see something from an unrealistically positive point of view"},
      {idiom: "Shed light upon", meaning: "to give new/further information"},
      {idiom: "Short and sweet", meaning: "very short and to the point"},
      {idiom: "Show one's true colours", meaning: "to reveal one's character"},
      {idiom: "Sleep like a log", meaning: "to sleep soundly"},
      {idiom: "Sleep on it", meaning: "to think about sth"},
      {idiom: "Slip one's mind", meaning: "to forget about sth"},
      {idiom: "Smell a rat", meaning: "to suspect that sth is wrong"},
      {idiom: "Speak volumes", meaning: "to be strong evidence of sb's merits etc"},
      {idiom: "Spill the beans", meaning: "to reveal a secret"},
      {idiom: "Stand in sb's way", meaning: "to prevent sb from doing sth"},
      {idiom: "Status symbol", meaning: "possession that shows sb's high social rank"},
      {idiom: "Stew in one's own juice", meaning: "to suffer the consequences of one's own actions"},
      {idiom: "Straight from the horse's mouth", meaning: "from the most direct source"},
      {idiom: "Strike gold", meaning: "to come across sth useful"},
      {idiom: "Take everything to heart", meaning: "to take personally/ be hurt by"},
      {idiom: "Take into account", meaning: "consider sth"},
      {idiom: "Take it easy", meaning: "to calm down"},
      {idiom: "Take one's time", meaning: "not to hurry"},
      {idiom: "Take it for granted", meaning: "to rely on sb to do things for you all the time"},
      {idiom: "Take it to heart", meaning: "to take personally, to be offended"},
      {idiom: "Take the bull by the horns", meaning: "to take a bold step immediately"},
      {idiom: "Take with a pinch of salt", meaning: "not to believe sth completely"},
      {idiom: "The black market", meaning: "illegal trading of goods"},
      {idiom: "The black sheep of the family", meaning: "a disgraced family member"},
      {idiom: "The boys in blue", meaning: "the police"},
      {idiom: "The ins and outs", meaning: "the details of an activity"},
      {idiom: "The last straw", meaning: "the last and worst episode in a chain of bad experiences"},
      {idiom: "The lesser of two evils", meaning: "when given two bad choices, the one which is not as bad as the other should be chosen over the one that is the greater threat"},
      {idiom: "The life and soul of sth", meaning: "the most lively and amusing person present somewhere"},
      {idiom: "The lion's share", meaning: "the biggest part/portion"},
      {idiom: "The rat race", meaning: "the competitive nature of modern urban life"},
      {idiom: "The tip of the iceberg", meaning: "small evident part of a much larger, concealed situation"},
      {idiom: "The year dot", meaning: "a long time ago"},
      {idiom: "Thick-skinned", meaning: "insensitive"},
      {idiom: "Through thick and thin", meaning: "whatever happens"},
      {idiom: "Throw a party", meaning: "to have a party"},
      {idiom: "Tongue in cheek", meaning: "not serious, ironic"},
      {idiom: "Tooth and nail", meaning: "fiercly"},
      {idiom: "Touch and go", meaning: "with uncertain result"},
      {idiom: "Turn a blind eye to sth", meaning: "to ignore"},
      {idiom: "Turn over a new leaf", meaning: "to make a new start"},
      {idiom: "Under the weather", meaning: "depressed, unwell"},
      {idiom: "Until one is blue in the face", meaning: "as hard/long as one possibly can"},
      {idiom: "Until the cows come home", meaning: "for a long time"},
      {idiom: "Up and coming", meaning: "likely to be successful"},
      {idiom: "Ups and downs", meaning: "alternate good and bad luck"},
      {idiom: "Wet blanket", meaning: "dull person who spoils people's happiness"},
      {idiom: "Wet behind the ears", meaning: "inexperienced"},
      {idiom: "Whet sb's appetite", meaning: "to make sb eager to have"},
      {idiom: "With flying colours", meaning: "with great success"},
      {idiom: "With one's heart in one's mouth", meaning: "fearfully"},
      {idiom: "White elephant", meaning: "useless possession"},
      {idiom: "Work a miracle", meaning: "to make sth impossible happen"},
      {idiom: "Work to rule", meaning: "to adhere strictly to the rules as a form of protest"}
    ]
  end
end
