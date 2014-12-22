module Plugins
  LANGUAGES = [:haskell, :prolog]

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
    case lang
      when 'prolog' then
        'http://cdn.portableapps.com/SWI-PrologPortable_128.png'
      when 'haskell' then
        'https://www.haskell.org/wikistatic/haskellwiki_logo.png'
      else
        raise "Unknown language #{lang}"
    end
  end

end

HaskellPlugin.send :include, Rails.application.config.haskell_plugin_type