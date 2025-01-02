namespace :english do
  # be rake english:parse_commonly_confused
  task parse_commonly_confused: :environment do
    file = File.join("data", "english", "commonly-confused-words.html")
    doc = Nokolexbor::HTML(File.read(file))
    doc.css("p").each do |p|
      words = []
      p.css("span").each do |span|
        words << span.text.to_s.downcase
      end
      pp words
    end
  end
end
