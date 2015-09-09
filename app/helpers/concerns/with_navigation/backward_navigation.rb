module WithNavigation
  class BackwardNavigation < Navigation
    include AnonymousNavigation

    def icon
      'chevron-circle-left'
    end

    def key
      :previous_exercise
    end

    def sibling_for(navigable)
      navigable.previous
    end
  end
end