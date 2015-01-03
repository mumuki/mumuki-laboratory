module ApplicationHelper
  include LinksRendering

  def limit(items, preserve_order = false)
    limited = items.last(5)
    limited = limited.reverse unless preserve_order
    limited
  end

  def highlighted_code(lang, code)
    "<pre><code class=\"hljs #{lang.name}\">#{code}</code></pre>".html_safe
  end

  def language_image_tag(lang)
    image_tag lang.image_url, alt: lang.name, height: 16
  end

  def status_span(status)
    "<span class=\"glyphicon glyphicon-#{glyphicon_for_status(status)}\"></span>".html_safe
  end

  def glyphicon_for_exercise(exercise)
    return nil unless current_user?

    if !exercise.submitted_by(current_user)
      "<span class='glyphicon glyphicon-certificate text-muted' aria-hidden='true'></span>".html_safe
     elsif exercise.solved_by?(current_user)
      "<span class='glyphicon glyphicon-certificate text-success' aria-hidden='true'></span>".html_safe
     else
      "<span class='glyphicon glyphicon-certificate text-danger' aria-hidden='true'></span>".html_safe
     end
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
