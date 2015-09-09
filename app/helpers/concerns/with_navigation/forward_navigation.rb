module WithNavigation
  class ForwardNavigation < Navigation
    include AnonymousNavigation

    def right
      true
    end

    def icon
      'chevron-circle-right'
    end

    def key
      :next_exercise
    end

    def sibling_for(navigable)
      navigable.next
    end
  end
end