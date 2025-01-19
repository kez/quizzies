module ApplicationHelper
  SUB = %w[₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉]
  SUP = %w[⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹]

  def fraction(numerator, denominator)
    numerator.digits.reverse.map { |char| SUP.fetch(char) }.join + "⁄" + denominator.digits.reverse.map { |char| SUB.fetch(char) }.join
  end

  def self.slugify(ret)
    # blow away apostrophes
    ret = ret.gsub(/['`]/, "")

    # @ --> at, and & --> and
    ret = ret.gsub(/\s*@\s*/, " at ")
    ret = ret.gsub(/\s*&\s*/, " and ")

    # replace all non alphanumeric, underscore or periods with hyphen
    ret = ret.gsub(/\s*[^A-Za-z0-9.]\s*/, "-")

    # convert double hyphens to single
    ret = ret.squeeze("-")
    ret = ret.gsub(/_+/, "-")
    ret = ret.delete(".")

    # strip off leading/trailing hyphen
    ret = ret.gsub(/\A[-.]+|[-.]+\z/, "")

    ret.downcase
  end

  def render_markdown(text)
    return nil unless text.present?
    Kramdown::Document.new(text).to_html.html_safe
  end
end
