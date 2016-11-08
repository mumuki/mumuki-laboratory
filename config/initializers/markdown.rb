module Mumukit::ContentType::Markdown
  def self.highlighted_code(language, code)
    "```#{language}\n#{code}```"
  end

  def self.inline_code(code)
    "`#{code}`"
  end
end
