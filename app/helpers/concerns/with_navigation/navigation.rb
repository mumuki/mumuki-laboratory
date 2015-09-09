module WithNavigation
  class Navigation
    def initialize(template)
      @template = template
    end

    def button(navigable)
      sibling = sibling_for(navigable)
      link_to link_icon, sibling, class: clazz if sibling
    end

    def link_icon
      fa_icon(icon, text: I18n.t(key), right: right)
    end

    def right
      false
    end

    def method_missing(name, *args, &block)
      @template.send(name, *args, &block)
    end
  end
end