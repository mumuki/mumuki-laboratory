module MarkdownHelper
  def code_to_markdown(language, code)
    Mumukit::ContentType::Markdown.highlighted_code language, code
  end

  def markdown_to_html(language, code)
    Mumukit::ContentType::Markdown.to_html code_to_markdown(language, code)
  end
end
