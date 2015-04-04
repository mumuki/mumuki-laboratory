module WithMarkup
  extend ActiveSupport::Concern

  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true)

  def with_markup(text)
    @@markdown.render(text).html_safe if text
  end

  module ClassMethods
    def markup_on(*selectors)
      selectors.each { |selector| _define_markup_on(selector) }
    end

    private

    def _define_markup_on(selector)
      define_method("#{selector}_html".to_sym) do |*args|
        with_markup self.send(selector, *args)
      end
    end
  end
end
