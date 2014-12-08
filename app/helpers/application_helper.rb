module ApplicationHelper
  def highlighted_code(lang, code)
    "<pre><code class=\"hljs #{lang}\">#{code}</code></pre>".html_safe
  end

  def language_image_tag(lang)
    image_tag language_image_url(lang), alt: lang, height: 16
  end

  def language_image_url(lang)
    case lang
      when 'prolog' then
        'http://cdn.portableapps.com/SWI-PrologPortable_128.png'
      when 'haskell' then
        'https://www.haskell.org/wikistatic/haskellwiki_logo.png'
    end
  end

  def restricted_to_current_user(exercise)
    yield if exercise.authored_by? current_user
  end
end
