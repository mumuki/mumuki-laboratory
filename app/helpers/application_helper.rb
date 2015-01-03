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
    glyphicon(glyphicon_for_status(status))
  end

  def glyphicon(name)
    "<span class=\"glyphicon glyphicon-#{name}\"></span>".html_safe
  end

  #TODO may reuse colors and icons with submission statuses
  def glyphicon_for_exercise(exercise)
    return nil unless current_user?
    text_class =
        if !exercise.submitted_by?(current_user)
          'text-muted'
        elsif exercise.solved_by?(current_user)
          'text-success'
        else
          'text-danger'
        end
    "<span class=\"glyphicon glyphicon-certificate #{text_class}\" aria-hidden=\"true\"></span>".html_safe
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
