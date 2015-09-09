module WithNavigation
  class RevisitNavigation < Navigation

    def icon
      :repeat
    end

    def key
      :repeat_pending
    end

    def clazz
      'btn btn-warning'
    end

    def sibling_for(navigable)
      navigable.first_for(current_user)
    end
  end
end