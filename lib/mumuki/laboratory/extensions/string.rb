class String
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
end

class NilClass
  def content_metadata
    ''
  end
end
