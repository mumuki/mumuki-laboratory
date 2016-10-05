module Mumukit::ContentType::Markdown
  def self.highlighted_code(code, language)
    "```#{language}\n#{code}```"
  end

  def self.inline_code(code)
    "`#{code}`"
  end
end
