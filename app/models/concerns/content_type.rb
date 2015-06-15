module ContentType
  def self.for(type)
    Kernel.const_get "ContentType::#{type.to_s.titleize}"
  end

  module Html
    def self.to_html(content)
      content.html_safe if content
    end
  end

  module Plain
    def self.to_html(content)
      "<pre>#{ERB::Util.html_escape content}</pre>".html_safe
    end
  end

  module Markdown
    require 'redcarpet'
    require 'rouge'
    require 'rouge/plugins/redcarpet'

    class HTML < MdEmoji::Render
      include Rouge::Plugins::Redcarpet
    end

    @@markdown = Redcarpet::Markdown.new(HTML, autolink: true, fenced_code_blocks: true, no_intra_emphasis: true, tables: true)

    def self.to_html(content)
      @@markdown.render(content).html_safe if content
    end
  end
end
