module WithStudentPathNavigation
  class ContinueNavigation < Navigation

    def button(navigable)
      sibling = sibling_for(navigable)
      link_to link_icon(sibling),
              sibling,
              merge_confirmation_classes(navigable, class: clazz) if sibling && sibling != navigable
    end

    def right
      true
    end

    def icon
      'chevron-right'
    end

    def key
      :navigation_continue
    end

    def clazz
      'btn btn-success btn-block'
    end

    def sibling_for(navigable)
      navigable.next_for(current_user)
    end
  end
end
