# Questions::Generate::Spelling::GenerateSpellingsJob.perform_now
class Questions::Generate::Spelling::GenerateSpellingsJob < ApplicationJob
  def perform(args = nil)
    words_file = "data/english/british_english_vocabulary.json"

    words = JSON.parse(File.read(words_file)).shuffle
    questions = []
    dir = "storage/words"
    FileUtils.mkdir_p(dir)
    ext = "mp3"

    words.each do |word|
      file = File.join(dir, "#{word}")

      [true, false].each do |slow_mode|
        output_file = "#{file}#{slow_mode ? "_slow" : ""}.#{ext}"
        next if File.exist?(output_file)
        resp = call_openai_tts(word, ext, slow_mode)

        json = JSON.parse(resp.read_body)
        puts "Running word #{word} with slow mode #{slow_mode}"
        begin
          data = json["choices"].first&.dig("message", "audio", "data")
        rescue Exception => e
          pp json
        end

        File.binwrite(output_file, Base64.decode64(data))
      end

      questions << {
        answer: word,
        question: word,
        data: {audio_file_1: "#{word}.mp3", audio_file_2: "#{word}_slow.mp3"}
      }
      break if questions.size > 10
    end

    questions
  end

  private

  require "net/http"
  require "json"

  def call_openai_tts(word, ext, slow_mode = false)
    uri = URI("https://api.openai.com/v1/chat/completions")

    # HTTP request body
    body = {
      model: "gpt-4o-audio-preview",
      modalities: %w[text audio],
      audio: {
        voice: :echo,
        format: ext.to_s
      },
      messages: [
        {
          role: "user",
          content: <<~PROMPT
            Say the word "#{word}" #{"slowly" if slow_mode}
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
