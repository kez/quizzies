class Blog < ApplicationRecord
  before_save :set_slug
  def published_date_friendly
    published_at.strftime("%d %B %Y")
  end

  def url
    "#{ENV.fetch("BASE_URL")}/blog/#{slug}" # if news_type == Types::News::BLOG
    # return  "#{ENV.fetch("BASE_URL")}/news/funding/#{slug}" if news_type == Types::News::PUBLIC_FUNDING
  end

  def set_slug
    return unless published_at.present?
    return if slug.present?
    self.slug = ApplicationHelper.slugify(title)
  end
end
