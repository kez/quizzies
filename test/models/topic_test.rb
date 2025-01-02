require "test_helper"

class TopicTest < ActiveSupport::TestCase
  test "the has correct parent topic assoication" do
    topic = topics(:homophones)
    parent_topic = topics(:english)
    assert topic.parent_topic_id == parent_topic.id
  end
end
