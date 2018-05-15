module WithStudentPathNavigation
  class Navigation
    def initialize(template)
      @template = template
    end

    def button(navigable)
      sibling = sibling_for(navigable)
      if sibling && sibling != navigable
        link_to link_icon(sibling), sibling, merge_confirmation_classes(navigable, class: clazz)
      else
        link_to I18n.t(:back_to_mumuki), root_path, merge_confirmation_classes(navigable, class: clazz)
      end
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
