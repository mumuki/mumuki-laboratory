module WithStudentPathNavigation
  class RevisitNavigation < Navigation

    def button(navigable)
      sibling = sibling_for(navigable)
      if sibling && sibling != navigable
        link_to link_icon(sibling), sibling, merge_confirmation_classes(navigable, class: clazz)
      else
        link_to I18n.t(:back_to_mumuki), root_path, merge_confirmation_classes(navigable, class: clazz)
      end
    end

    def right
      true
    end

    def icon
      'chevron-right'
    end

    def key
      :navigation_revisit
    end

    def clazz
      'btn btn-warning btn-block'
    end

    def sibling_for(navigable)
      navigable.restart(current_user)
    end
  end
end
