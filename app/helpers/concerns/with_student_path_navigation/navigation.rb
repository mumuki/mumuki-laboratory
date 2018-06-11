module WithStudentPathNavigation
  class Navigation
    def initialize(template)
      @template = template
    end

    def link_icon(sibling)
      fa_icon(icon, text: I18n.t(key, sibling: sibling.name, kind: I18n.t(sibling.class.model_name.name.downcase)), right: right)
    end

    def right
      false
    end

    def merge_confirmation_classes(navigable, base_classes)
      if navigable.is_a? Reading
        base_classes.merge class: "btn-confirmation #{base_classes[:class]}",
                           'data-confirmation-url': exercise_confirmations_path(navigable)
      else
        base_classes
      end
      .merge role: "button"
    end

    def method_missing(name, *args, &block)
      @template.send(name, *args, &block)
    end
  end
end
