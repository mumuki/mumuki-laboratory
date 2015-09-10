module WithNavigation
  class BackwardNavigation < Navigation
    include AnonymousNavigation

    def icon
      'chevron-circle-left'
    end

    def key
      :navigation_previous
    end

    def sibling_for(navigable)
      navigable.previous
    end
  end
end