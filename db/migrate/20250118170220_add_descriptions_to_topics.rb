class AddDescriptionsToTopics < ActiveRecord::Migration[8.0]
  def change
    remove_column :topics, :nanoid, :string
    remove_column :quizzes, :nanoid, :string
    remove_column :super_topics, :nanoid, :string

    add_column :topics, :summary, :string
    add_column :topics, :help_text, :string

    add_column :super_topics, :summary, :string
    # add_column :super_topics, :description, :string
  end
end
