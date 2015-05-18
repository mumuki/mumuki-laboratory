module ContentType
  def self.for(type)
    Kernel.const_get "ContentType::#{type.to_s.titleize}"
  end

  module Html
    def self.render(content)
      content.html_safe
    end
  end

  module Plain
    def self.render(content)
      content
    end
  end
end
