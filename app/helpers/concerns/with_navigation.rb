module WithNavigation
  def next_button(navigable) #TODO duplicated logic with next_guides_box
    sibling_button(navigable.next_for(current_user), :next_exercise, 'chevron-right', 'btn btn-success', true) ||
        sibling_button(navigable., :repeat_pending, :repeat, '')
  end

  def next_nav_button(navigable)
    ForwardNavigation.new.button(navigable)
  end

  def previous_nav_button(navigable)
    BackwardNavigation.new.button(navigable)
  end

  class Navigation
    def button(navigable)
      sibling = sibling_for(navigable)
      link_to link_icon, sibling, class: clazz if sibling
    end

    def link_icon
      fa_icon(icon, text: t(key), right: right)
    end

    def right
      false
    end
  end

  module AnonymousNavigation
    def clazz
      'text-info'
    end
  end

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

  class RevisitNavigation < Navigation

    def icon
      :repeat
    end

    def key
      :repeat
    end

    def clazz
      'btn btn-warning'
    end

    def sibling_for(navigable)
      navigable.first_for(current_user)
    end
  end

  class ContinueNavigation < Navigation
    def sibling_for(navigable)
      navigable.next_for(current_user)
    end
  end
end
