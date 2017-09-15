module ResetButtonHelper
  def reset_button
    fa_icon('trash-o', class: 'fa-fw', role: 'button', tabindex: '0', 'aria-label': 'Reiniciar')
  end

end
