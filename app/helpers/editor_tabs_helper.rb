module EditorTabsHelper
  def extra_code_tab
    "<li role='presentation'>
        <a class='editor-tab nav-link' data-bs-target='#visible-extra' aria-controls='visible-extra' role='tab' data-bs-toggle='tab'>
          #{fa_icon 'code', text: (t 'activerecord.attributes.exercise.extra')}
        </a>
    </li>".html_safe
  end

  def console_tab(active: false)
    "<li role='presentation'>
        <a class='editor-tab nav-link #{'active' if active}' data-bs-target='#console' aria-controls='console' tabindex='0' role='tab' data-bs-toggle='tab' >
          #{fa_icon 'terminal', text: (t :console)}
        </a>
     </li>".html_safe
  end

  def messages_tab(exercise, organization = Organization.current)
    "<li id='messages-tab' role='presentation'>
        <a class='editor-tab nav-link' data-bs-target='#messages' tabindex='0' aria-controls='console' role='tab' data-bs-toggle='tab'>
          #{fa_icon 'comments', type: :regular, text: (t :messages)}
        </a>
     </li>".html_safe if organization.raise_hand_enabled? && exercise.has_messages_for?(current_user)
  end
end
