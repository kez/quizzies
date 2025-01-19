# Questions::Generate::Spelling::GenerateSpellingsJob.perform_now
class Questions::Generate::Spelling::GenerateSpellingsJob < ApplicationJob
  def perform(args = nil)
    words_file = "data/english/british_english_vocabulary.json"

    words = JSON.parse(File.read(words_file))
    questions = []
    dir = "storage/words"
    FileUtils.mkdir_p(dir)
    ext = "aiff"

    words.each do |word|
      next if word == "all right"
      file = File.join(dir, "#{word}")
      Rails.logger.info "Generating audio for #{word}"
      [true, false].each do |slow_mode|
        output_file = "#{file}#{slow_mode ? "_slow" : ""}.#{ext}"

        next if File.exist?(output_file)
        cmd = if slow_mode
          "say -r 2 -o #{output_file} #{word}"
        else
          "say -o #{output_file} #{word}"
        end

        `#{cmd}`
        `ffmpeg -i #{output_file} -c:a aac -b:a 128k -f mp4 #{output_file.gsub("aiff", "mp4")}`
      end

      questions << {
        answer: word,
        question: word,
        data: {audio_file_1: "#{word}.mp4", audio_file_2: "#{word}_slow.mp4"}
      }
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
