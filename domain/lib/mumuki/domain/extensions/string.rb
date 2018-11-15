class String

  # Adds a newline character unless
  # this string is empty or already ends with a newline
  # See https://unix.stackexchange.com/a/18789
  def ensure_newline
    empty? || ends_with?("\n") ? self : self + "\n"
  end

  def friendlish
    I18n.transliterate(self).
      downcase.
      gsub(/[^0-9a-z ]/, '').
      squish.
      gsub(' ', '-')
  end

  def markdown_paragraphs
    split(/\n\s*\n/)
  end

  def normalize_whitespaces
    gsub(/([^[:ascii:]])/) { $1.blank? ? ' ' : $1 }
  end

  def file_extension
    File.extname(self).delete '.'
  end
end
