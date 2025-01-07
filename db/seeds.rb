# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by(name: genre_name)
#   end

super_topic = SuperTopic.find_or_create_by(title: "11 Plus", country_code: "GB", key: "11-plus")
maths_topic = Topic.unscoped.find_or_create_by(title: "Maths", super_topic:, key: "maths")
english_topic = Topic.unscoped.find_or_create_by(title: "English", super_topic:, key: "english")
spelling_punctuation_topic = Topic.unscoped.find_or_create_by(title: "Spelling and Punctuation", super_topic:, key: "spelling_punctuation")

verbal_reasoning_topic = Topic.unscoped.find_or_create_by(title: "Verbal Reasoning", super_topic:, key: "verbal_reasoning")
Topic.unscoped.find_or_create_by(title: "Non-verbal Reasoning", super_topic:, key: "non_verbal_reasoning")
Topic.unscoped.find_or_create_by(title: "Vocabulary", super_topic:, key: "vocabulary")
Topic.unscoped.find_or_create_by(title: "Comprehension", super_topic:, key: "comprehension")

%w[multiplication_division
  ratio
  rounding
  proportions_of_numbers
  place_value_multiplication_division
  place_values
  sequence_progression].each do |question_type|
    Topic.unscoped.find_or_create_by(parent_topic: maths_topic, key: question_type, title: question_type.humanize, super_topic:)
  end

%w[homophones antonyms synonyms idioms best_missing_words commonly_confused_words].each do |question_type|
  Topic.unscoped.find_or_create_by(parent_topic: english_topic, key: question_type, title: question_type.humanize, super_topic:)
end

%w[spellings ie_ei_words commonly_misspelled_words].each do |question_type|
  Topic.unscoped.find_or_create_by(parent_topic: spelling_punctuation_topic, key: question_type, title: question_type.humanize, super_topic:)
end

%w[word_ladders].each do |question_type|
  Topic.unscoped.find_or_create_by(parent_topic: verbal_reasoning_topic, key: question_type, title: question_type.humanize, super_topic:)
end
