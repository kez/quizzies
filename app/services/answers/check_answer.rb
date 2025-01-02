class Answers::CheckAnswer < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct
  output :feedback

  play Answers::English::Homophones,
    Answers::English::Antonyms,
    Answers::English::Idioms,
    Answers::Maths::MultiplicationDivisionOrOther,
    Answers::SpellingPunctuation::Spellings,
    Answers::SpellingPunctuation::IeEiWords,
    Answers::SpellingPunctuation::CommonlyMisspelledWords,
    Answers::English::BestMissingWords,
    Answers::English::CommonlyConfusedWords
end
