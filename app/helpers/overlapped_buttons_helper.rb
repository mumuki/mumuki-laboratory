module OverlappedButtonsHelper
  def restart_icon
    overlapped_button_icon :restart, :undo
  end

  def format_icon
    overlapped_button_icon :format, :indent
  end

  def restart_guide_link(guide)
    link_to restart_icon, guide_progress_path(guide), class: 'mu-content-toolbar-item', data: {confirm: t(:confirm_restart)}, method: :delete
  end

  def overlapped_button_icon(key, icon)
    fa_icon(icon, title: t(key), class: 'fa-fw', role: 'button', 'aria-label': t(key))
  end
end
