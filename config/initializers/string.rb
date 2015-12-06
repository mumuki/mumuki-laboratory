class String
  def sluggish
    I18n.transliterate(self).
        downcase.
        gsub(/[^0-9a-z ]/, '').
        squish.
        gsub(' ', '-')
  end
end