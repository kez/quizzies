# Questions::Generate::VerbalReasoning::GenerateWordLaddersJob.perform_now
class Questions::Generate::VerbalReasoning::GenerateWordLaddersJob < ApplicationJob
  def perform(args = nil)
    questions = []
    word_ladders.each do |ladder|
      next if ladder.first == ladder.last
      questions << {
        answer: [ladder[1], ladder[2]],
        question: [ladder[0], ladder[-1]].to_json
      }
    end

    questions
  end

  private

  def word_ladders
    [
      ["hand", "hard", "ward", "word"],
      ["hand", "hard", "ward", "card"],
      ["hand", "hard", "card", "ward"],
      ["hand", "hard", "card", "care"],
      ["hand", "sand", "band", "bank"],
      ["hand", "sand", "band", "land"],
      ["hand", "sand", "land", "band"],
      ["hand", "sand", "land", "lane"],
      ["hand", "band", "bank", "bark"],
      ["hand", "band", "land", "sand"],
      ["hand", "land", "lane", "lame"],
      ["hand", "land", "lane", "late"],
      ["game", "lame", "lane", "land"],
      ["game", "lame", "lane", "late"],
      ["game", "lame", "same", "came"],
      ["game", "lame", "came", "care"],
      ["game", "lame", "came", "same"],
      ["game", "lame", "late", "lane"],
      ["game", "lame", "late", "gate"],
      ["game", "lame", "late", "fate"],
      ["game", "lame", "late", "mate"],
      ["game", "lame", "late", "date"],
      ["game", "lame", "late", "rate"],
      ["game", "lame", "late", "hate"],
      ["game", "same", "came", "lame"],
      ["game", "came", "care", "card"],
      ["game", "came", "care", "bare"],
      ["load", "goad", "gold", "cold"],
      ["load", "goad", "gold", "bold"],
      ["load", "goad", "gold", "hold"],
      ["load", "goad", "gold", "told"],
      ["load", "goad", "gold", "fold"],
      ["bark", "bare", "care", "card"],
      ["bark", "bare", "care", "came"],
      ["bark", "bank", "band", "sand"],
      ["bark", "bank", "band", "hand"],
      ["bark", "bank", "band", "land"],
      ["mate", "gate", "game", "lame"],
      ["mate", "gate", "game", "same"],
      ["mate", "gate", "game", "came"],
      ["mate", "gate", "fate", "date"],
      ["mate", "gate", "fate", "rate"],
      ["mate", "gate", "fate", "late"],
      ["mate", "gate", "fate", "hate"],
      ["mate", "gate", "date", "fate"],
      ["mate", "gate", "late", "lane"],
      ["mate", "fate", "gate", "game"],
      ["mate", "fate", "date", "gate"],
      ["mate", "late", "lane", "land"],
      ["hold", "cold", "gold", "goad"],
      ["hold", "cold", "gold", "bold"],
      ["hold", "cold", "gold", "told"],
      ["hold", "cold", "gold", "fold"],
      ["hold", "cold", "bold", "gold"],
      ["hold", "gold", "goad", "load"],
      ["hold", "gold", "bold", "cold"],
      ["same", "lame", "lane", "land"],
      ["same", "lame", "lane", "late"],
      ["same", "lame", "came", "care"],
      ["same", "lame", "came", "game"],
      ["same", "lame", "game", "came"],
      ["same", "lame", "game", "gate"],
      ["same", "lame", "late", "lane"],
      ["same", "lame", "late", "fate"],
      ["same", "lame", "late", "mate"],
      ["same", "lame", "late", "date"],
      ["same", "lame", "late", "rate"],
      ["same", "lame", "late", "hate"],
      ["same", "came", "care", "card"],
      ["same", "came", "care", "bare"],
      ["same", "came", "game", "lame"],
      ["sand", "band", "bank", "bark"],
      ["sand", "band", "hand", "hard"],
      ["sand", "band", "hand", "land"],
      ["sand", "band", "land", "hand"],
      ["spine", "shine", "shone", "shore"],
      ["spine", "shine", "shone", "stone"],
      ["spine", "spike", "spice", "slice"],
      ["spine", "spike", "spoke", "smoke"],
      ["spine", "spice", "spike", "spoke"],
      ["spine", "spice", "slice", "slide"],
      ["slice", "spice", "spine", "shine"],
      ["slice", "spice", "spine", "spike"],
      ["slice", "spice", "spike", "spine"],
      ["slice", "spice", "spike", "spoke"],
      ["stone", "store", "stare", "start"],
      ["stone", "store", "stare", "spare"],
      ["stone", "store", "stare", "share"],
      ["stone", "store", "score", "shore"],
      ["stone", "store", "shore", "score"],
      ["stone", "store", "shore", "shone"],
      ["stone", "shone", "shore", "store"],
      ["stone", "shone", "shine", "spine"],
      ["smart", "start", "stare", "spare"],
      ["smart", "start", "stare", "store"],
      ["smart", "start", "stare", "share"],
      ["shore", "store", "stare", "start"],
      ["shore", "store", "stare", "spare"],
      ["shore", "store", "stare", "share"],
      ["shore", "store", "stone", "shone"],
      ["shore", "score", "store", "stare"],
      ["shore", "score", "store", "stone"],
      ["shore", "share", "stare", "store"],
      ["shore", "share", "shape", "shade"],
      ["shore", "share", "shade", "shape"],
      ["shore", "shone", "shine", "spine"],
      ["shape", "share", "spare", "stare"],
      ["shape", "share", "stare", "start"],
      ["shape", "share", "stare", "spare"],
      ["shape", "share", "stare", "store"],
      ["shape", "share", "shore", "score"],
      ["shape", "share", "shore", "shone"],
      ["shape", "shade", "share", "shore"],
      ["shine", "shone", "shore", "store"],
      ["shine", "shone", "shore", "score"],
      ["shine", "shone", "shore", "share"],
      ["shine", "spine", "spike", "spice"],
      ["shine", "spine", "spike", "spoke"],
      ["shine", "spine", "spice", "spike"],
      ["shine", "spine", "spice", "slice"],
      ["store", "stare", "start", "smart"],
      ["store", "stare", "spare", "share"],
      ["store", "stare", "share", "spare"],
      ["store", "stare", "share", "shore"],
      ["store", "stare", "share", "shape"],
      ["store", "stare", "share", "shade"],
      ["store", "score", "shore", "shone"],
      ["store", "shore", "share", "stare"],
      ["store", "shore", "shone", "shine"],
      ["store", "shore", "shone", "stone"],
      ["spike", "spine", "shine", "shone"],
      ["spike", "spine", "spice", "slice"],
      ["spike", "spice", "spine", "shine"],
      ["spike", "spice", "slice", "slide"],
      ["spike", "spoke", "smoke", "smote"],
      ["smoke", "spoke", "spike", "spine"],
      ["smoke", "spoke", "spike", "spice"],
      ["shone", "shore", "store", "stare"],
      ["shone", "shore", "store", "score"],
      ["shone", "shore", "store", "stone"],
      ["shone", "shore", "score", "store"],
      ["shone", "shore", "share", "spare"],
      ["shone", "shore", "share", "shape"],
      ["shone", "shore", "share", "shade"],
      ["shone", "shine", "spine", "spike"],
      ["shone", "shine", "spine", "spice"],
      ["shone", "stone", "store", "shore"],
      ["start", "stare", "spare", "share"],
      ["start", "stare", "store", "score"],
      ["start", "stare", "store", "shore"],
      ["strife", "strike", "stripe", "strive"],
      ["strife", "strike", "strive", "stripe"],
      ["strife", "stripe", "strive", "strike"],
      ["stripe", "strike", "strive", "strife"],
      ["stripe", "strike", "strife", "strive"],
      ["stripe", "strive", "strife", "strike"],
      ["strong", "string", "spring", "sprung"],
      ["strong", "string", "spring", "sprint"],
      ["strike", "stripe", "strive", "strife"],
      ["strike", "stripe", "strife", "strive"],
      ["strike", "strive", "strife", "stripe"],
      ["strive", "strike", "stripe", "strife"],
      ["strive", "strike", "strife", "stripe"],
      ["strive", "stripe", "strife", "strike"],
      ["saints", "paints", "prints", "points"],
      ["saints", "paints", "points", "prints"],
      ["points", "prints", "paints", "saints"],
      ["sprint", "spring", "string", "strong"],
      ["sprung", "spring", "string", "strong"],
      ["prints", "points", "paints", "saints"]
    ]
  end
end
