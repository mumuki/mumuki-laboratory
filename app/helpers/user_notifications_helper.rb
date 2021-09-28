module UserNotificationsHelper

  def user_notifications_table_title(notification, last_read)
    <<~HTML.html_safe
      <tr></tr>
      <thead>
        <tr>
          <td class="#{last_read.nil? ? '' : 'pt-5'}" colspan="100%">
            <strong>#{notification.read? ? t(:discussions_read) : t(:discussions_unread)}</strong>
          </td>
        </tr>
      </thead>
    HTML
  end

  def user_notifications_table_header
    <<~HTML.html_safe
      <tr class="fw-bold">
        <td></td>
        <td>#{ t :notification }</td>
        <td>#{ t :created_at }</td>
      </tr>
    HTML
  end

  def user_notifications_table_item(notification)
    <<~HTML.html_safe
      <tr>
        <td class="mu-readable-item-icon">
          #{ link_to icon_for_read(notification.read?),
                     "notifications/#{notification.id}/toggle_read",
                     tooltip_options(:toggle_read).merge(method: :post, role: :button) }
        </td>
        <td class="text-break mu-notifications-content">
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
        </td>
        <td class="col-md-3">
          #{ friendly_time(notification.created_at, :time_since) }
        </td>
      </tr>
    HTML
  end
end
