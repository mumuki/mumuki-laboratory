module Plugins
  LANGUAGES = [:haskell, :prolog]

  def self.find_by_language(lang)
    Kernel.const_get("#{lang.to_s.titleize}Plugin".to_sym).new
  end

  def self.language_for_extension(extension)
    case extension
      when 'hs' then
        :haskell
      when 'pl' then
        :prolog
      else
        raise "Unknown extension #{extension}"
    end
  end

  def self.language_image_url_for(lang)
    find_by_language(lang).image_url
  end
end
