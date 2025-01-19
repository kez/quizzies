class Question < ApplicationRecord
  belongs_to :topic

  def topic
    Topic.unscoped { super }
  end
end
