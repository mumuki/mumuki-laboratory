module EditorTabsHelper
  def extra_code_tab

    "<li role='presentation'> <a data-target='#visible-extra' aria-controls='visible-extra' role='tab' data-toggle='tab' class='editor-tab'>#{fa_icon 'code'} #{t 'activerecord.attributes.exercise.extra'}</a> </li>".html_safe
  end

  def console_tab
    "<li role='presentation'> <a data-target='#console' aria-controls='console' role='tab' data-toggle='tab' class='editor-tab'>#{fa_icon 'terminal'} #{t :console }</a> </li>".html_safe
  end

  def messages_tab(hidden)
    "<li id='messages-tab' role='presentation' class=\"#{hidden_class(hidden)}\"> <a data-target='#messages' aria-controls='console' role='tab' data-toggle='tab' class='editor-tab'>#{fa_icon 'comments-o'} #{t :messages }</a> </li>".html_safe
  end

  def hidden_class(hidden)
    hidden ? 'hidden' : ''
  end
end
