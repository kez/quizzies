# Questions::Generate::Maths::GenerateRatioQuestionsJob.perform_now
class Questions::Generate::Maths::GenerateRatioQuestionsJob < ApplicationJob
  queue_as :default

  def perform(questions_to_generate = 10)
    # Generate ratio questions dynamically with a broader range of variants

    questions = []

    # Expanded entities with corresponding group variants
    entity_groups = {
      "animals in a zoo" => [
        ["lions", "tigers"],
        ["elephants", "zebras"],
        ["monkeys", "giraffes"],
        ["penguins", "seals"]
      ],
      "types of cars in a parking lot" => [
        ["sedans", "SUVs"],
        ["red cars", "blue cars"],
        ["electric cars", "petrol cars"],
        ["trucks", "convertibles"]
      ],
      "types of drinks at a party" => [
        ["sodas", "juices"],
        ["coffee", "tea"],
        ["water bottles", "energy drinks"],
        ["smoothies", "cocktails"]
      ],
      "pieces of candy in a jar" => [
        ["chocolates", "gummies"],
        ["lollipops", "mints"],
        ["hard candies", "jelly beans"],
        ["toffees", "caramels"]
      ],
      "plants in a garden" => [
        ["flowers", "trees"],
        ["roses", "daisies"],
        ["shrubs", "vines"],
        ["cacti", "ferns"]
      ],
      "sports players on a field" => [
        ["football players", "basketball players"],
        ["pitchers", "batters"],
        ["defenders", "attackers"],
        ["goalkeepers", "forwards"]
      ],
      "workers in an office" => [
        ["engineers", "designers"],
        ["managers", "interns"],
        ["salespeople", "marketers"],
        ["technicians", "supervisors"]
      ],
      "books in a library" => [
        ["fiction books", "non-fiction books"],
        ["mystery novels", "romance novels"],
        ["hardcovers", "paperbacks"],
        ["science books", "history books"]
      ],
      "toys in a toy box" => [
        ["action figures", "dolls"],
        ["cars", "planes"],
        ["stuffed animals", "puzzles"],
        ["building blocks", "board games"]
      ],
      "houses in a neighborhood" => [
        ["brick houses", "wooden houses"],
        ["single-family houses", "duplexes"],
        ["modern houses", "traditional houses"],
        ["small houses", "large houses"]
      ]
    }

    questions_to_generate.times do
      # Randomly select an entity and its group variants
      entity, groups = entity_groups.to_a.sample
      group_names = groups.sample

      total = rand(20..50) # Total number of items
      ratio_first = rand(1..4) # Ratio of the first group
      ratio_second = rand(2..5) # Ratio of the second group

      # Ensure total is divisible by the sum of the ratio
      total_ratio = ratio_first + ratio_second
      total = (total / total_ratio) * total_ratio # Adjust total to fit ratio

      # Calculate the number of items in each group
      groups_count = total / total_ratio
      first_group = groups_count * ratio_first
      second_group = groups_count * ratio_second

      # Formulate the question and answer
      question = {
        question: "There are #{total} #{entity}. There are #{ratio_first} #{group_names[0]} for every #{ratio_second} #{group_names[1]}. How many #{group_names[0]} are there?",
        answer: first_group
      }

      questions << question
    end
    questions
  end
end
