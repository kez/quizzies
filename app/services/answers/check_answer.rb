class Answers::CheckAnswer < Actor
  input :question, type: "Question"
  input :input, type: Object

  output :correct

  play Answers::English::Homophones,
    Answers::English::Antonyms,
    Answers::English::Idioms,
    Answers::Maths::MultiplicationDivisionOrOther,
    Answers::SpellingPunctuation::Spellings,
    Answers::English::BestMissingWords
end
