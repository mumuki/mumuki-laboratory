module ApplicationHelper
  include WithStudentPathNavigation

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

  def corollary_box(with_corollary)
    if with_corollary.corollary.present?
      %Q{
      <div class="corollary-box">
        <p>#{with_corollary.corollary_html}</p>
      </div>
}.html_safe
    end
  end

  def tips_box(assignment)
    tips = assignment.tips
    if tips.present?
      explanation = Mumukit::Assistant::Narrator.sample.compose_explanation tips
    %Q{<div class="mu-tips-box">
        #{Mumukit::ContentType::Markdown.to_html explanation}
      </div>}.html_safe
    end
  end

  def chapter_finished(chapter)
    t :chapter_finished_html, chapter: link_to_path_element(chapter) if chapter
  end
end
