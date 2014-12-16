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
      else raise "Unknown language #{lang}"
    end
  end

  def status_span(status)
    "<span class=\"glyphicon glyphicon-#{glyphicon_for_status(status)}\"></span>".html_safe
  end

  def link_to_exercise(exercise)
    link_to exercise.title, exercise
  end

  def paginate(object)
    super(object, theme: 'twitter-bootstrap-3')
  end

  def taglist_tag(tags)
    #TODO use it also for writable inputs
    box_options, input_options = ['readonly', 'readonly disabled']
    %Q{<div class="taglist-box #{box_options}">
        <input type="text" value="#{tags}" data-role="tagsinput" #{input_options}>
       </div>}.html_safe
  end

  private

  def glyphicon_for_status(status)
    case status
      when 'passed' then 'ok'
      when 'failed' then 'remove'
      when 'running' then 'time'
      when 'pending' then 'time'
      else raise "Unknown status #{status}"
    end
  end
end
