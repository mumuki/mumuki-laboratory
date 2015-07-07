module WithNavigation
  def next_button(navigable)
    sibling_button(navigable.next_for(current_user), :next_exercise, 'chevron-right', 'btn btn-success', true)
  end

  def next_nav_button(navigable)
    sibling_button(navigable.next, :next_exercise, 'chevron-circle-right', 'text-info', true)
  end

  def previous_nav_button(navigable)
    sibling_button(navigable.previous, :previous_exercise, 'chevron-circle-left', 'text-info')
  end

  def sibling_button(sibling, key, icon, clazz, right=false)
    link_to fa_icon(icon, text: t(key), right: right), sibling, class: clazz if sibling
  end
end
