module WithNavigation
  class RevisitNavigation < Navigation

    def icon
      :repeat
    end

    def key
      :navigation_revisit
    end

    def clazz
      'btn btn-warning'
    end

    def sibling_for(navigable)
      navigable.first_for(current_user)
    end
  end
end