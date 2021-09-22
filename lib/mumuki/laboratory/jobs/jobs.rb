Mumukit::Nuntius::JobConsumer.handle do
  # Emitted by assigment manual evaluation in classroom
  job 'CreateMassiveNotifications' do |payload|
    body = payload.with_indifferent_access
    Notification.create_massive_notifications_for!(body[:notification], body[:uids])
  end

  job 'SendNotificationEmail' do |payload|
    Notification.notify_via_email! payload.with_indifferent_access[:notification_id]
  end
end
