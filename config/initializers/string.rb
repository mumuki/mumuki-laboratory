class String
  def friendlish
    I18n.transliterate(self).
        downcase.
        gsub(/[^0-9a-z ]/, '').
        squish.
        gsub(' ', '-')
  end
end
