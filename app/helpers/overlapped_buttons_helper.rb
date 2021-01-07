module OverlappedButtonsHelper
  def expand_icon
    overlapped_button_icon :fullscreen, :expand, " (F11)"
  end

  def restart_icon
    overlapped_button_icon :restart, :undo
  end

  def format_icon
    overlapped_button_icon :format, :indent
  end

  def restart_guide_link(guide)
    link_to restart_icon, guide_progress_path(guide), class: 'mu-content-toolbar-item mu-restart-guide', data: {confirm: t(:confirm_restart)}, method: :delete
  end

  def overlapped_button_icon(key, icon, extra_title='')
    fa_icon(icon, title: t(key) + extra_title, class: 'fa-fw', role: 'button', 'aria-label': t(key), 'data-placement': 'left')
  end
end
