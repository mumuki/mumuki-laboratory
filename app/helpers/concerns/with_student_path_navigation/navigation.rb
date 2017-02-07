module WithStudentPathNavigation
  class Navigation
    def initialize(template)
      @template = template
    end

    def button(navigable)
      sibling = sibling_for(navigable)
      link_to link_icon(sibling), sibling, class: clazz if sibling && sibling != navigable
    end

    def link_icon(sibling)
      fa_icon(icon, text: I18n.t(key, sibling: sibling.name, kind: I18n.t(sibling.class.model_name.name.downcase)), right: right)
    end

    def right
      false
    end

    def method_missing(name, *args, &block)
      @template.send(name, *args, &block)
    end
  end
end
