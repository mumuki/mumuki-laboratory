module ContentType
  def self.for(type)
    Kernel.const_get "ContentType::#{type.to_s.titleize}"
  end

  module Html
    def self.render(content)
      content.html_safe if content
    end
  end

  module Plain
    def self.render(content)
      content
    end
  end

  module Markdown
    @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, fenced_code_blocks: true)

    def self.render(content)
      @@markdown.render(content).html_safe if content
    end
  end
end
