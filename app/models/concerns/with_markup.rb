module WithMarkup
  extend ActiveSupport::Concern

  module ClassMethods
    def markup_on(*selectors)
      selectors.each { |selector| _define_markup_on(selector) }
    end

    private

    def _define_markup_on(selector)
      define_method("#{selector}_html".to_sym) do |*args|
        ContentType::Markdown.render self.send(selector, *args)
      end
    end
  end
end
