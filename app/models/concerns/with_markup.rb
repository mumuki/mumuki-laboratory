module WithMarkup
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)

  def with_markup(text)
    @@markdown.render(text).html_safe
  end
end