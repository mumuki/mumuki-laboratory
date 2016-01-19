class Module
  def markdown_on(*selectors)
    selectors.each { |selector| _define_markdown_on(selector) }
  end

  private

  def _define_markdown_on(selector)
    define_method("#{selector}_html".to_sym) do |*args|
      ContentType::Markdown.to_html self.send(selector, *args)
    end
  end
end