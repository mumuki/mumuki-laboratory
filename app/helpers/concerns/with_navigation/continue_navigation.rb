module WithNavigation
  class ContinueNavigation < Navigation
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
      'btn btn-success'
    end

    def sibling_for(navigable)
      navigable.next_for(current_user)
    end
  end
end
