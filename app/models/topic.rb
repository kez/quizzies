class Topic < ApplicationRecord
  has_prefix_id :t
  default_scope { where(status: 1) }

  belongs_to :super_topic
  has_many :sub_topics, class_name: "Topic", foreign_key: "parent_topic_id"
  belongs_to :parent_topic, class_name: "Topic", optional: true
  has_many :questions

  def published_status
    (status == 1) ? "Published" : "Draft"
  end
end
