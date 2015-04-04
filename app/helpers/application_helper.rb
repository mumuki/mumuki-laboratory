module ApplicationHelper
  include LinksRendering
  include Icons
  include Flags
  include ExpectationsTranslate

  def limit(items, preserve_order = false)
    limited = items.last(5)
    limited = limited.reverse unless preserve_order
    limited
  end

  def highlighted_code(lang, code)
    "<pre><code class=\"hljs #{lang.name}\">#{code}</code></pre>".html_safe
  end

  def paginate(object, options={})
    "<div class=\"text-center\">#{super(object, {theme: 'twitter-bootstrap-3'}.merge(options))}</div>".html_safe
  end

  def taglist_tag(tags)
    #TODO use it also for writable inputs
    box_options, input_options = ['readonly', 'readonly disabled']
    %Q{<div class="taglist-box #{box_options}">
        <input type="text" value="#{tags}" data-role="tagsinput" #{input_options}>
       </div>}.html_safe
  end

  def link_to_tag_list(tags)
    tags.map { |tag| link_to "##{tag}", exercises_path(q: tag) }.join(', ').html_safe
  end

  def active_if(expected)
    'class="active"'.html_safe if expected == @current_tab
  end

  def stats(stats, k)
    "#{stats.send k} #{status_icon(k)} ".html_safe
  end

  def practice_key_for(stats)
    if stats.started?
      :continue_practicing
    else
      :start_practicing
    end
  end

  def repeat_submission_button(exercise)
    link_to fa_icon(:repeat, text: t(:repeat_submission)), exercise_path(exercise), class: 'btn btn-primary'
  end

  def next_exercise_button(exercise)
    next_exercise = exercise.next_for current_user
    link_to fa_icon(:forward, text: t(:next_exercise)), exercise_path(next_exercise), class: 'btn btn-primary' if next_exercise
  end

  def previous_exercise_button(exercise)
    previous_exercise = exercise.previous_for current_user
    link_to fa_icon(:backward, text: t(:previous_exercise)), exercise_path(previous_exercise), class: 'btn btn-primary' if previous_exercise
  end

  def time_ago_in_words_or_never(date)
    date ? time_ago_in_words(date) : t(:never)
  end
end
