module OverlappedButtonsHelper
  def expand_icon
    overlapped_button_icon :fullscreen, :expand
  end

  def restart_icon(data_placement='left')
    overlapped_button_icon :restart, :undo, data_placement
  end

  def format_icon
    overlapped_button_icon :format, :indent
  end

  def restart_guide_link(guide)
    link_to restart_icon('top'),
            guide_progress_path(guide),
            class: 'mu-content-toolbar-item mu-restart-guide',
            data: {confirm: t(:confirm_restart)},
            method: :delete
  end

  def overlapped_button_icon(key, icon, data_placement='left')
    fa_icon(icon, title: t(key), class: 'fa-fw', role: 'button', 'aria-label': t(key), 'data-placement': data_placement)
  end
end
