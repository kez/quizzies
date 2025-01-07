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
      ["flat", "flap", "slap", "slit"],
      ["plot", "plow", "glow", "slow"],
      ["mist", "most", "host", "holt"],
      ["fire", "firm", "form", "fork"],
      ["care", "card", "ward", "warm"],
      ["deck", "duck", "dusk", "disk"],
      ["link", "pink", "punk", "puck"],
      ["bent", "belt", "bolt", "boat"],
      ["fond", "find", "fine", "fire"],
      ["gift", "rift", "raft", "rant"],
      ["hold", "cold", "cord", "core"],
      ["past", "part", "port", "post"],
      ["raid", "said", "sand", "band"],
      ["soft", "soot", "boot", "boat"],
      ["wise", "wine", "line", "lone"],
      ["tale", "tile", "time", "tome"],
      ["cram", "clam", "clap", "clip"],
      ["foil", "coil", "cool", "tool"],
      ["year", "tear", "team", "beam"],
      ["cook", "book", "boom", "room"],
      ["dark", "park", "perk", "peak"],
      ["gold", "fold", "fond", "find"],
      ["read", "lead", "lend", "land"],
      ["spin", "spit", "slit", "slip"],
      ["leaf", "leap", "heap", "hear"],
      ["duck", "luck", "lurk", "turn"],
      ["coin", "loin", "loan", "load"],
      ["help", "helm", "hell", "hill"],
      ["mute", "mule", "mile", "mice"],
      ["chip", "chap", "clap", "clan"],
      ["bend", "lend", "land", "lane"],
      ["file", "fire", "hire", "hike"],
      ["vote", "note", "nate", "mate"],
      ["trap", "trip", "drip", "drop"],
      ["rise", "ride", "rude", "rule"],
      ["twin", "twit", "twit", "twig"],
      ["bark", "bank", "band", "land"],
      ["lamp", "limp", "lime", "time"],
      ["mark", "mask", "task", "tack"],
      ["foam", "farm", "form", "worm"],
      ["lend", "land", "lane", "late"],
      ["pile", "pike", "bike", "bite"],
      ["bold", "bond", "bend", "send"],
      ["camp", "lamp", "lame", "lane"],
      ["trip", "grip", "grin", "grid"],
      ["name", "game", "gate", "gale"],
      ["curl", "hurl", "hurd", "hard"],
      ["hand", "land", "lane", "late"],
      ["vent", "went", "want", "wart"],
      ["yard", "hard", "harp", "warp"],
      ["cold", "cord", "core", "care"],
      ["beam", "ream", "rear", "fear"],
      ["star", "scar", "scab", "stab"],
      ["dock", "rock", "rack", "rack"],
      ["glad", "grad", "grid", "grip"],
      ["flip", "flap", "slap", "slip"],
      ["bare", "bore", "core", "cure"],
      ["rest", "nest", "next", "text"],
      ["hunt", "hurt", "hurl", "curl"],
      ["fire", "hire", "hike", "bike"],
      ["fold", "gold", "bold", "bald"],
      ["hint", "mint", "mind", "kind"],
      ["work", "word", "cord", "card"],
      ["bank", "bark", "barn", "bane"],
      ["coin", "join", "joke", "poke"],
      ["lamp", "lamb", "limb", "limp"],
      ["walk", "wall", "well", "bell"],
      ["rate", "mate", "male", "mule"],
      ["life", "line", "lime", "time"],
      ["back", "rack", "rake", "lake"]
    ]
  end
end
