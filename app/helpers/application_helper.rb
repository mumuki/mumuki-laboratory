module ApplicationHelper
  #FIXME only include what is needed
  include WithLinksRendering
  include WithIcons
  include WithNavigation
  include WithStatusRendering

  def contact_email
    Organization.current.contact_email
  end

  def page_title(subject)
    if subject && !subject.new_record?
      "#{subject.friendly} - Mumuki"
    else
      "Mumuki - #{t :mumuki_catchphrase}"
    end
  end

  def paginate(object, options={})
    "<div class=\"text-center\">#{super(object, {theme: 'twitter-bootstrap-3'}.merge(options))}</div>".html_safe
  end

  def link_to_tag_list(tags)
    tags.map { |tag| link_to "##{tag}", exercises_path(q: tag) }.join(', ').html_safe
  end

  def active_if(expected, current=@current_tab)
    'class="active"'.html_safe if expected == current
  end

  def time_ago_in_words_or_never(date)
    date ? time_ago_in_words(date) : t(:never)
  end

  def chapter_finished(guide)
    t :chapter_finished_html, chapter: link_to_path_element(@guide.chapter) if @guide.chapter
  end

  def corollary_box(with_corollary)
    if with_corollary.corollary.present?
      "<div><h3>#{t :corollary}</h3><p>#{with_corollary.corollary_html}</p></div>".html_safe
    end
  end
end
