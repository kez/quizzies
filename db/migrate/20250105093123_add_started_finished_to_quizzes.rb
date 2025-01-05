class AddStartedFinishedToQuizzes < ActiveRecord::Migration[8.0]
  def change
    add_column :quizzes, :started_at, :datetime
    add_column :quizzes, :finished_at, :datetime
  end
end
