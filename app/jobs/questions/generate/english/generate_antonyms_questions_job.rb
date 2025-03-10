# Questions::Generate::English::GenerateAntonymsQuestionsJob.perform_now
class Questions::Generate::English::GenerateAntonymsQuestionsJob < ApplicationJob
  queue_as :default

  def perform(questions_to_generate = 10)
    questions = []
    antonyms.take(questions_to_generate).each do |antonym|
      questions << {
        question: antonym[:word],
        answer: antonym[:antonyms].first.split(",").map(&:strip)
      }
    end

    questions
  end

  private

  def antonyms
    @antonyms = [
      {word: "above", antonyms: ["below"]},
      {word: "absent", antonyms: ["present"]},
      {word: "abundant", antonyms: ["scarce"]},
      {word: "accept", antonyms: ["decline, refuse"]},
      {word: "accident", antonyms: ["intent"]},
      {word: "accomplishment", antonyms: ["failure"]},
      {word: "accurate", antonyms: ["inaccurate"]},
      {word: "achieve", antonyms: ["fail"]},
      {word: "add", antonyms: ["subtract"]},
      {word: "adjacent", antonyms: ["distant"]},
      {word: "admire", antonyms: ["detest"]},
      {word: "admit", antonyms: ["deny, reject"]},
      {word: "adore", antonyms: ["hate"]},
      {word: "advance", antonyms: ["retreat"]},
      {word: "advantage", antonyms: ["disadvantage"]},
      {word: "affirm", antonyms: ["deny"]},
      {word: "afraid", antonyms: ["confident"]},
      {word: "after", antonyms: ["before"]},
      {word: "against", antonyms: ["for"]},
      {word: "agree", antonyms: ["disagree"]},
      {word: "aid", antonyms: ["hinder"]},
      {word: "alert", antonyms: ["asleep"]},
      {word: "alive", antonyms: ["dead"]},
      {word: "all", antonyms: ["none, nothing"]},
      {word: "allow", antonyms: ["forbid"]},
      {word: "ally", antonyms: ["enemy"]},
      {word: "alone", antonyms: ["together"]},
      {word: "always", antonyms: ["never"]},
      {word: "amateur", antonyms: ["professional"]},
      {word: "amuse", antonyms: ["bore"]},
      {word: "ancient", antonyms: ["modern"]},
      {word: "answer", antonyms: ["question"]},
      {word: "antonym", antonyms: ["synonym"]},
      {word: "apart", antonyms: ["together"]},
      {word: "apparent", antonyms: ["obscure"]},
      {word: "appear", antonyms: ["disappear, vanish"]},
      {word: "approve", antonyms: ["disapprove"]},
      {word: "argue", antonyms: ["agree"]},
      {word: "arrive", antonyms: ["depart"]},
      {word: "arrogant", antonyms: ["humble"]},
      {word: "artificial", antonyms: ["natural"]},
      {word: "ascend", antonyms: ["descend"]},
      {word: "attack", antonyms: ["defend"]},
      {word: "attract", antonyms: ["repel"]},
      {word: "attractive", antonyms: ["repulsive"]},
      {word: "awake", antonyms: ["asleep"]},
      {word: "awkward", antonyms: ["graceful"]},
      {word: "back", antonyms: ["front"]},
      {word: "backward", antonyms: ["forward"]},
      {word: "bad", antonyms: ["good"]},
      {word: "beautiful", antonyms: ["ugly"]},
      {word: "before", antonyms: ["after"]},
      {word: "begin", antonyms: ["end"]},
      {word: "below", antonyms: ["above"]},
      {word: "bent", antonyms: ["straight"]},
      {word: "best", antonyms: ["worst"]},
      {word: "better", antonyms: ["worse, worst"]},
      {word: "big", antonyms: ["little, small"]},
      {word: "birth", antonyms: ["death"]},
      {word: "bitter", antonyms: ["sweet"]},
      {word: "black", antonyms: ["white"]},
      {word: "blame", antonyms: ["praise"]},
      {word: "bless", antonyms: ["curse"]},
      {word: "blunt", antonyms: ["sharp"]},
      {word: "bold", antonyms: ["timid, meek"]},
      {word: "borrow", antonyms: ["lend"]},
      {word: "bottom", antonyms: ["top"]},
      {word: "bound", antonyms: ["unbound, free"]},
      {word: "boundless", antonyms: ["limited"]},
      {word: "bravery", antonyms: ["cowardice"]},
      {word: "break", antonyms: ["repair"]},
      {word: "brief", antonyms: ["long"]},
      {word: "bright", antonyms: ["dim, dull"]},
      {word: "brighten", antonyms: ["fade"]},
      {word: "broad", antonyms: ["narrow"]},
      {word: "build", antonyms: ["destroy"]},
      {word: "busy", antonyms: ["idle"]},
      {word: "buy", antonyms: ["sell"]},
      {word: "calm", antonyms: ["windy, troubled"]},
      {word: "can", antonyms: ["cannot, can't"]},
      {word: "capable", antonyms: ["incapable"]},
      {word: "captive", antonyms: ["free"]},
      {word: "capture", antonyms: ["release"]},
      {word: "careful", antonyms: ["careless"]},
      {word: "cause", antonyms: ["effect"]},
      {word: "cautious", antonyms: ["careless"]},
      {word: "centre", antonyms: ["edge"]},
      {word: "cheap", antonyms: ["dear, expensive"]},
      {word: "cheerful", antonyms: ["sad, discouraged, dreary"]},
      {word: "child", antonyms: ["adult"]},
      {word: "chilly", antonyms: ["warm"]},
      {word: "clean", antonyms: ["dirty"]},
      {word: "clear", antonyms: ["vague, cloudy, opaque"]},
      {word: "clever", antonyms: ["stupid"]},
      {word: "clockwise", antonyms: ["anti-clockwise"]},
      {word: "close", antonyms: ["distant, open"]},
      {word: "cold", antonyms: ["hot"]},
      {word: "combine", antonyms: ["separate"]},
      {word: "come", antonyms: ["go"]},
      {word: "comfort", antonyms: ["discomfort"]},
      {word: "common", antonyms: ["rare"]},
      {word: "complex", antonyms: ["simple"]},
      {word: "compliment", antonyms: ["insult"]},
      {word: "conceal", antonyms: ["reveal"]},
      {word: "constant", antonyms: ["variable"]},
      {word: "continue", antonyms: ["interrupt"]},
      {word: "cool", antonyms: ["warm"]},
      {word: "cope", antonyms: ["original"]},
      {word: "correct", antonyms: ["incorrect"]},
      {word: "courage", antonyms: ["cowardice"]},
      {word: "crazy", antonyms: ["sane"]},
      {word: "crooked", antonyms: ["staight"]},
      {word: "cruel", antonyms: ["kind"]},
      {word: "cry", antonyms: ["laugh"]},
      {word: "cunning", antonyms: ["simple"]},
      {word: "dainty", antonyms: ["clumsy"]},
      {word: "damage", antonyms: ["improve"]},
      {word: "danger", antonyms: ["safety"]},
      {word: "dark", antonyms: ["light"]},
      {word: "dawn", antonyms: ["sunset"]},
      {word: "day", antonyms: ["night"]},
      {word: "decrease", antonyms: ["increase"]},
      {word: "deep", antonyms: ["shallow"]},
      {word: "definite", antonyms: ["indefinite"]},
      {word: "demand", antonyms: ["supply"]},
      {word: "despair", antonyms: ["hope"]},
      {word: "destroy", antonyms: ["create"]},
      {word: "difficult", antonyms: ["easy"]},
      {word: "dim", antonyms: ["bright"]},
      {word: "disappear", antonyms: ["appear"]},
      {word: "discourage", antonyms: ["encourage"]},
      {word: "disease", antonyms: ["health"]},
      {word: "dismal", antonyms: ["cheerful"]},
      {word: "divide", antonyms: ["unite"]},
      {word: "doubt", antonyms: ["trust"]},
      {word: "down", antonyms: ["up"]},
      {word: "downwards", antonyms: ["upwards"]},
      {word: "dreary", antonyms: ["cheerful"]},
      {word: "dry", antonyms: ["moist, wet"]},
      {word: "dull", antonyms: ["bright, shiny"]},
      {word: "dusk", antonyms: ["dawn"]},
      {word: "early", antonyms: ["late"]},
      {word: "east", antonyms: ["west"]},
      {word: "easy", antonyms: ["hard, difficult"]},
      {word: "economise", antonyms: ["waste"]},
      {word: "empty", antonyms: ["full"]},
      {word: "encourage", antonyms: ["discourage"]},
      {word: "end", antonyms: ["begin, start"]},
      {word: "entrance", antonyms: ["exit"]},
      {word: "even", antonyms: ["odd"]},
      {word: "evil", antonyms: ["good"]},
      {word: "excited", antonyms: ["calm"]},
      {word: "expand", antonyms: ["contract, shrink"]},
      {word: "export", antonyms: ["import"]},
      {word: "exterior", antonyms: ["interior"]},
      {word: "external", antonyms: ["internal"]},
      {word: "fade", antonyms: ["brighten"]},
      {word: "fail", antonyms: ["succeed"]},
      {word: "false", antonyms: ["true"]},
      {word: "famous", antonyms: ["unknown"]},
      {word: "fancy", antonyms: ["plain"]},
      {word: "far", antonyms: ["near"]},
      {word: "fast", antonyms: ["slow"]},
      {word: "fat", antonyms: ["thin"]},
      {word: "feeble", antonyms: ["sturdy, strong, powerful"]},
      {word: "few", antonyms: ["many"]},
      {word: "fiction", antonyms: ["fact"]},
      {word: "find", antonyms: ["lose"]},
      {word: "finish", antonyms: ["start"]},
      {word: "firm", antonyms: ["flabby"]},
      {word: "first", antonyms: ["last"]},
      {word: "fix", antonyms: ["break"]},
      {word: "float", antonyms: ["sink"]},
      {word: "fold", antonyms: ["unfold"]},
      {word: "follow", antonyms: ["lead"]},
      {word: "foolish", antonyms: ["wise"]},
      {word: "for", antonyms: ["against"]},
      {word: "fore", antonyms: ["aft"]},
      {word: "forget", antonyms: ["remember"]},
      {word: "forgive", antonyms: ["blame"]},
      {word: "fortunate", antonyms: ["unfortunate"]},
      {word: "found", antonyms: ["lost"]},
      {word: "frank", antonyms: ["secretive"]},
      {word: "free", antonyms: ["bound, captive, restricted"]},
      {word: "frequent", antonyms: ["seldom"]},
      {word: "fresh", antonyms: ["stale"]},
      {word: "friend", antonyms: ["enemy"]},
      {word: "full", antonyms: ["empty"]},
      {word: "funny", antonyms: ["empty"]},
      {word: "future", antonyms: ["present, past"]},
      {word: "gather", antonyms: ["distribute"]},
      {word: "generous", antonyms: ["stingy, mean"]},
      {word: "gentle", antonyms: ["rough, violent"]},
      {word: "get", antonyms: ["give"]},
      {word: "giant", antonyms: ["tiny, small, dwarf"]},
      {word: "give", antonyms: ["receive, take"]},
      {word: "glad", antonyms: ["sad, sorry"]},
      {word: "gloomy", antonyms: ["cheerful"]},
      {word: "go", antonyms: ["stop, come"]},
      {word: "good", antonyms: ["bad, evil"]},
      {word: "grant", antonyms: ["refuse"]},
      {word: "great", antonyms: ["tiny, small, unimportant, minute"]},
      {word: "grow", antonyms: ["shrink"]},
      {word: "guest", antonyms: ["host"]},
      {word: "guilty", antonyms: ["innocent"]},
      {word: "handsome", antonyms: ["ugly"]},
      {word: "happy", antonyms: ["sad, miserable"]},
      {word: "hard", antonyms: ["easy"]},
      {word: "hard", antonyms: ["soft"]},
      {word: "harmful", antonyms: ["harmless"]},
      {word: "harsh", antonyms: ["mild"]},
      {word: "hasten", antonyms: ["dawdle"]},
      {word: "hate", antonyms: ["love"]},
      {word: "healthy", antonyms: ["diseased, ill, sick, unhealthy"]},
      {word: "heat", antonyms: ["cold"]},
      {word: "heaven", antonyms: ["hell"]},
      {word: "heavy", antonyms: ["light"]},
      {word: "help", antonyms: ["hinder"]},
      {word: "here", antonyms: ["there"]},
      {word: "hero", antonyms: ["coward"]},
      {word: "high", antonyms: ["low"]},
      {word: "hill", antonyms: ["valley"]},
      {word: "hinder", antonyms: ["help"]},
      {word: "honest", antonyms: ["dishonest"]},
      {word: "hopeful", antonyms: ["hopeless"]},
      {word: "horizontal", antonyms: ["vertical"]},
      {word: "hot", antonyms: ["cold"]},
      {word: "huge", antonyms: ["tiny"]},
      {word: "humble", antonyms: ["proud"]},
      {word: "ignore", antonyms: ["notice"]},
      {word: "ill", antonyms: ["healthy, well"]},
      {word: "imitation", antonyms: ["genuine"]},
      {word: "immense", antonyms: ["minute, tiny, small"]},
      {word: "immigrate", antonyms: ["emigrate"]},
      {word: "important", antonyms: ["trivial"]},
      {word: "imprison", antonyms: ["free"]},
      {word: "in", antonyms: ["out"]},
      {word: "include", antonyms: ["exclude"]},
      {word: "increase", antonyms: ["decrease"]},
      {word: "inferior", antonyms: ["superior"]},
      {word: "inhale", antonyms: ["exhale"]},
      {word: "inner", antonyms: ["outer"]},
      {word: "innocent", antonyms: ["guilty"]},
      {word: "inside", antonyms: ["outside"]},
      {word: "intelligent", antonyms: ["stupid, unintelligent"]},
      {word: "intentional", antonyms: ["accidental"]},
      {word: "interesting", antonyms: ["boring, dull, uninteresting"]},
      {word: "interior", antonyms: ["exterior"]},
      {word: "internal", antonyms: ["external"]},
      {word: "jeopardize", antonyms: ["secure"]},
      {word: "join", antonyms: ["separate"]},
      {word: "junior", antonyms: ["senior"]},
      {word: "just", antonyms: ["unjust"]},
      {word: "justice", antonyms: ["injustice"]},
      {word: "keen", antonyms: ["uninterested"]},
      {word: "kind", antonyms: ["cruel, nasty"]},
      {word: "knowledge", antonyms: ["ignorance"]},
      {word: "known", antonyms: ["unknown"]},
      {word: "lack", antonyms: ["abundance, plenty"]},
      {word: "landlord", antonyms: ["tenant"]},
      {word: "large", antonyms: ["small"]},
      {word: "last", antonyms: ["first"]},
      {word: "late", antonyms: ["early"]},
      {word: "laugh", antonyms: ["cry"]},
      {word: "lawful", antonyms: ["unlawful, illegal"]},
      {word: "lazy", antonyms: ["industrious"]},
      {word: "leader", antonyms: ["follower"]},
      {word: "left", antonyms: ["right"]},
      {word: "lend", antonyms: ["borrow"]},
      {word: "lengthen", antonyms: ["shorten"]},
      {word: "lenient", antonyms: ["strict"]},
      {word: "less", antonyms: ["more"]},
      {word: "life", antonyms: ["death"]},
      {word: "light", antonyms: ["dark, heavy"]},
      {word: "like", antonyms: ["dislike, hate"]},
      {word: "likely", antonyms: ["unlikely"]},
      {word: "limited", antonyms: ["boundless"]},
      {word: "little", antonyms: ["big"]},
      {word: "live", antonyms: ["die"]},
      {word: "lofty", antonyms: ["lowly"]},
      {word: "long", antonyms: ["short"]},
      {word: "loose", antonyms: ["tight"]},
      {word: "lose", antonyms: ["find"]},
      {word: "loser", antonyms: ["winner"]},
      {word: "loss", antonyms: ["win"]},
      {word: "loud", antonyms: ["quiet"]},
      {word: "love", antonyms: ["hate"]},
      {word: "low", antonyms: ["high"]},
      {word: "lower", antonyms: ["raise"]},
      {word: "loyal", antonyms: ["disloyal"]},
      {word: "mad", antonyms: ["happy, sane"]},
      {word: "major", antonyms: ["minor"]},
      {word: "many", antonyms: ["few"]},
      {word: "mature", antonyms: ["immature"]},
      {word: "maximum", antonyms: ["minimum"]},
      {word: "mean", antonyms: ["generous"]},
      {word: "melt", antonyms: ["freeze"]},
      {word: "mend", antonyms: ["break"]},
      {word: "merry", antonyms: ["sad"]},
      {word: "messy", antonyms: ["neat"]},
      {word: "minor", antonyms: ["major"]},
      {word: "minority", antonyms: ["majority"]},
      {word: "miser", antonyms: ["spendthrift"]},
      {word: "miss", antonyms: ["catch"]},
      {word: "misunderstand", antonyms: ["understand"]},
      {word: "more", antonyms: ["less"]},
      {word: "much", antonyms: ["little"]},
      {word: "narrow", antonyms: ["wide, broad"]},
      {word: "native", antonyms: ["foreigner, stranger"]},
      {word: "natural", antonyms: ["artificial"]},
      {word: "near", antonyms: ["far, distant"]},
      {word: "neat", antonyms: ["messy, untidy"]},
      {word: "negative", antonyms: ["affirmative"]},
      {word: "never", antonyms: ["always"]},
      {word: "new", antonyms: ["old, ancient"]},
      {word: "nice", antonyms: ["awful, nasty"]},
      {word: "night", antonyms: ["day"]},
      {word: "no", antonyms: ["yes"]},
      {word: "nobody", antonyms: ["everybody"]},
      {word: "noisy", antonyms: ["quiet"]},
      {word: "none", antonyms: ["some"]},
      {word: "north", antonyms: ["south"]},
      {word: "nothing", antonyms: ["everything"]},
      {word: "notice", antonyms: ["ignore"]},
      {word: "now", antonyms: ["then"]},
      {word: "obedient", antonyms: ["disobedient"]},
      {word: "occasionally", antonyms: ["frequently"]},
      {word: "odd", antonyms: ["even"]},
      {word: "offer", antonyms: ["refuse"]},
      {word: "often", antonyms: ["seldom, sometimes"]},
      {word: "old", antonyms: ["new"]},
      {word: "old", antonyms: ["young"]},
      {word: "on", antonyms: ["off"]},
      {word: "open", antonyms: ["closed, shut"]},
      {word: "opposite", antonyms: ["same, similar"]},
      {word: "optimist", antonyms: ["pessimist"]},
      {word: "order", antonyms: ["mess"]},
      {word: "out", antonyms: ["in"]},
      {word: "outer", antonyms: ["inner"]},
      {word: "outside", antonyms: ["inside"]},
      {word: "outskirts", antonyms: ["centre"]},
      {word: "over", antonyms: ["under"]},
      {word: "pass", antonyms: ["fail"]},
      {word: "past", antonyms: ["present"]},
      {word: "patient", antonyms: ["impatient"]},
      {word: "peace", antonyms: ["war"]},
      {word: "permanent", antonyms: ["temporary"]},
      {word: "permit", antonyms: ["forbid"]},
      {word: "please", antonyms: ["displease"]},
      {word: "plentiful", antonyms: ["scarce"]},
      {word: "plural", antonyms: ["singular"]},
      {word: "poetry", antonyms: ["prose"]},
      {word: "polite", antonyms: ["rude, impolite"]},
      {word: "poor", antonyms: ["rich, wealthy"]},
      {word: "possible", antonyms: ["impossible"]},
      {word: "poverty", antonyms: ["wealth, riches"]},
      {word: "poverty", antonyms: ["wealth"]},
      {word: "powerful", antonyms: ["weak, feeble"]},
      {word: "presence", antonyms: ["absence"]},
      {word: "pretty", antonyms: ["ugly"]},
      {word: "private", antonyms: ["public"]},
      {word: "prudent", antonyms: ["imprudent"]},
      {word: "pure", antonyms: ["impure, contaminated"]},
      {word: "push", antonyms: ["pull"]},
      {word: "qualified", antonyms: ["unqualified"]},
      {word: "question", antonyms: ["answer"]},
      {word: "quick", antonyms: ["slow"]},
      {word: "quiet", antonyms: ["loud, noisy"]},
      {word: "raise", antonyms: ["lower"]},
      {word: "rapid", antonyms: ["slow"]},
      {word: "rare", antonyms: ["common"]},
      {word: "real", antonyms: ["fake"]},
      {word: "rear", antonyms: ["front"]},
      {word: "receive", antonyms: ["send"]},
      {word: "reduce", antonyms: ["increase"]},
      {word: "refuse", antonyms: ["agree, accept"]},
      {word: "regular", antonyms: ["irregular"]},
      {word: "rest", antonyms: ["work"]},
      {word: "rich", antonyms: ["poor"]},
      {word: "right-side-up", antonyms: ["upside-down"]},
      {word: "right", antonyms: ["left, wrong"]},
      {word: "rough", antonyms: ["smooth, soft, gentle"]},
      {word: "rude", antonyms: ["courteous"]},
      {word: "sad", antonyms: ["happy"]},
      {word: "safe", antonyms: ["unsafe, dangerous"]},
      {word: "same", antonyms: ["opposite, different"]},
      {word: "satisfy", antonyms: ["unsatisfied, dissatisfy"]},
      {word: "scatter", antonyms: ["collect"]},
      {word: "second-hand", antonyms: ["new"]},
      {word: "secure", antonyms: ["insecure"]},
      {word: "security", antonyms: ["insecurity"]},
      {word: "seldom", antonyms: ["often"]},
      {word: "senior", antonyms: ["junior"]},
      {word: "sense", antonyms: ["nonsense"]},
      {word: "separate", antonyms: ["join, connect, together"]},
      {word: "serious", antonyms: ["trivial, funny"]},
      {word: "shallow", antonyms: ["deep"]},
      {word: "sharp", antonyms: ["blunt"]},
      {word: "short", antonyms: ["long"]},
      {word: "shrink", antonyms: ["grow"]},
      {word: "shut", antonyms: ["open"]},
      {word: "sick", antonyms: ["healthy, ill"]},
      {word: "simple", antonyms: ["complex, hard, complicated"]},
      {word: "singular", antonyms: ["plural"]},
      {word: "sink", antonyms: ["float"]},
      {word: "slim", antonyms: ["fat, thick, stout"]},
      {word: "slow", antonyms: ["fast"]},
      {word: "smooth", antonyms: ["rough"]},
      {word: "sober", antonyms: ["drunk"]},
      {word: "soft", antonyms: ["hard"]},
      {word: "solid", antonyms: ["liquid"]},
      {word: "some", antonyms: ["none"]},
      {word: "sorrow", antonyms: ["joy"]},
      {word: "sour", antonyms: ["sweet"]},
      {word: "sow", antonyms: ["reap"]},
      {word: "stand", antonyms: ["lie"]},
      {word: "start", antonyms: ["finish"]},
      {word: "stop", antonyms: ["go"]},
      {word: "straight", antonyms: ["crooked"]},
      {word: "strict", antonyms: ["lenient, indulgent"]},
      {word: "strong", antonyms: ["weak"]},
      {word: "success", antonyms: ["failure"]},
      {word: "sunny", antonyms: ["cloudy"]},
      {word: "sweet", antonyms: ["sour"]},
      {word: "synonym", antonyms: ["antonym"]},
      {word: "take", antonyms: ["give"]},
      {word: "tall", antonyms: ["short"]},
      {word: "tame", antonyms: ["wild"]},
      {word: "them", antonyms: ["us"]},
      {word: "there", antonyms: ["here"]},
      {word: "thick", antonyms: ["thin"]},
      {word: "throw", antonyms: ["catch"]},
      {word: "tight", antonyms: ["loose, slack"]},
      {word: "tiny", antonyms: ["big, huge"]},
      {word: "together", antonyms: ["apart"]},
      {word: "top", antonyms: ["bottom"]},
      {word: "tough", antonyms: ["easy, tender"]},
      {word: "transparent", antonyms: ["opaque"]},
      {word: "true", antonyms: ["false"]},
      {word: "truth", antonyms: ["lie, untruth"]},
      {word: "under", antonyms: ["over"]},
      {word: "unfold", antonyms: ["fold"]},
      {word: "unity", antonyms: ["division"]},
      {word: "unknown", antonyms: ["known"]},
      {word: "unqualified", antonyms: ["qualified"]},
      {word: "unsafe", antonyms: ["safe"]},
      {word: "up", antonyms: ["down"]},
      {word: "upside-down", antonyms: ["right-side-up"]},
      {word: "upstairs", antonyms: ["downstairs"]},
      {word: "us", antonyms: ["them"]},
      {word: "useful", antonyms: ["useless"]},
      {word: "vacant", antonyms: ["occupied"]},
      {word: "valuable", antonyms: ["valueless"]},
      {word: "vanish", antonyms: ["appear"]},
      {word: "vast", antonyms: ["tiny"]},
      {word: "victory", antonyms: ["defeat"]},
      {word: "virtue", antonyms: ["vice"]},
      {word: "visible", antonyms: ["invisible"]},
      {word: "voluntary", antonyms: ["compulsory"]},
      {word: "vowel", antonyms: ["consonant"]},
      {word: "war", antonyms: ["peace"]},
      {word: "wax", antonyms: ["wane"]},
      {word: "weak", antonyms: ["strong, powerful"]},
      {word: "weak", antonyms: ["strong"]},
      {word: "wet", antonyms: ["dry"]},
      {word: "white", antonyms: ["black"]},
      {word: "wide", antonyms: ["narrow"]},
      {word: "win", antonyms: ["lose"]},
      {word: "wisdom", antonyms: ["folly, stupidity"]},
      {word: "within", antonyms: ["outside"]},
      {word: "worse", antonyms: ["better"]},
      {word: "worst", antonyms: ["best"]},
      {word: "wrong", antonyms: ["right"]},
      {word: "yes", antonyms: ["no"]},
      {word: "young", antonyms: ["old"]},
      {word: "zip", antonyms: ["unzip"]}
    ].sort_by { rand }
  end
end
