module ResetButtonHelper
  def restart_icon
    fa_icon('trash-o', title: t(:restart), class: 'fa-fw', role: 'button', tabindex: '0', 'aria-label': t(:restart))
  end

  def restart_guide_link(guide)
    link_to restart_icon, guide_progress_path(guide), data: {confirm: t(:confirm_restart)}, method: :delete
  end

end
