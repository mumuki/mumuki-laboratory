module WithMarkup
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true)

  def with_markup(text)
    @@markdown.render(text).html_safe
  end
end