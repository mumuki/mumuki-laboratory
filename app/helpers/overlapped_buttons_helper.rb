module OverlappedButtonsHelper
  def restart_icon
    fa_icon('undo', title: t(:restart), class: 'fa-fw', role: 'button', tabindex: '0', 'aria-label': t(:restart))
  end

  def format_icon
    fa_icon('indent', title: t(:format), class: 'fa-fw', role: 'button', tabindex: '0', 'aria-label': t(:indent))
  end

  def restart_guide_link(guide)
    link_to restart_icon, guide_progress_path(guide), class: 'mu-content-toolbar-item', data: {confirm: t(:confirm_restart)}, method: :delete
  end
end
