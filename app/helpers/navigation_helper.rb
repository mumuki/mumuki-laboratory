module NavigationHelper
  def next_button(navigable)
    return unless navigable
    ContinueNavigation.new(self).button(navigable) || RevisitNavigation.new(self).button(navigable)
  end

  class Navigation
    def initialize(template)
      @template = template
    end

    def button(navigable)
      sibling = sibling_for(navigable)
      link_to link_icon(sibling), sibling, class: clazz if sibling && sibling != navigable
    end

    def link_icon(sibling)
      fa_icon(icon, text: I18n.t(key, sibling: sibling.name, kind: I18n.t(sibling.class.model_name.name.downcase)), right: right)
    end

    def right
      false
    end

    def method_missing(name, *args, &block)
      @template.send(name, *args, &block)
    end
  end

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
      'btn btn-success btn-block'
    end

    def sibling_for(navigable)
      navigable.next_for(current_user)
    end
  end

  class RevisitNavigation < Navigation
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
