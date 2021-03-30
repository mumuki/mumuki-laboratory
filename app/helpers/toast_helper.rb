module ToastHelper
  def toast_notice(text)
    toast_for('success', 'check-circle', text)
  end

  def toast_alert(text)
    toast_for('error', 'times-circle', text)
  end

  def toast_info(text)
    toast_for('info', 'info-circle', text)
  end

  private

  def toast_for(type, icon, text)
    "<div class='toast mu-toast-#{type}' role='alert'>
       <div class='toast-body'>
         <div class='d-flex align-items-center'>
           #{fa_icon icon, class: 'fa-lg me-3'}
           <span class='flex-grow-1 text-break'>#{text}</span>
           <button type='button' class='btn-close btn-close-white mx-2 flex-shrink-0' data-bs-dismiss='toast' aria-label='Close'></button>
         </div>
       </div>
     </div>".html_safe
  end
end
