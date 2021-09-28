module UserNotificationsHelper
  def notification_toggle_read(notification)
    link_to icon_for_read(notification.read?),
            "notifications/#{notification.id}/toggle_read",
            tooltip_options(:toggle_read).merge(method: :post, role: :button)
  end

  def notification_content(notification)
    <<~HTML.html_safe
      <div class="mu-notifications-title">
        #{ render partial: "notifications/titles/#{notification.subject}", locals: { notification: notification } }
      </div>
      <div class="mu-notifications-body">
        <div class="mu-notifications-body-content">
          #{ render partial: "notifications/#{notification.subject}", locals: { notification: notification } }
        </div>
      </div>
      <button class="mu-notifications-arrow" onclick="$(this).parent().toggleClass('opened')">
        <i class="fas fa-fw fa-angle-down"></i>
      </button>
    HTML
  end
end
