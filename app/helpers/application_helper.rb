module ApplicationHelper
  include WithStudentPathNavigation

  # html-escapes an string even if it is html-safe
  def html_rescape(html)
    html_escape html.to_str
  end

  def profile_picture_for(user, **options)
    default_options = { height: 40, onError: "this.onerror = null; this.src = '#{image_url(user.placeholder_image_url)}'" }
    avatar_image(user.profile_picture, default_options.merge(options))
  end

  def avatar_image(avatar_url, **options)
    options.merge!(class: "img-circle #{options[:class]}")
    image_tag(image_url(avatar_url), options)
  end

  def paginate(object, options = {})
    "<div class=\"text-center\">#{super(object, {theme: 'twitter-bootstrap-3'}.merge(options))}</div>".html_safe
  end

  def last_box_class(trailing_boxes)
    trailing_boxes ? '' : 'mu-last-box'
  end

  def corollary_box(with_corollary, trailing_boxes = false)
    if with_corollary.corollary.present?
      %Q{
        <div class="#{last_box_class trailing_boxes}">
          <p>#{with_corollary.corollary_html}</p>
        </div>
      }.html_safe
    end
  end

  def chapter_finished(chapter)
    t :chapter_finished_html, chapter: link_to_path_element(chapter) if chapter
  end

  def span_toggle(hidden_text, active_text, active, **options)
    %Q{
      <span class="#{'d-none' if active} #{options[:class]}">#{hidden_text}</span>
      <span class="#{'d-none' unless active} #{options[:class]}">#{active_text}</span>
    }.html_safe
  end

  def notification_preview_for(target)
    render "notifications/#{target.class.name.underscore}", { target: target }
  end
end
