Mumukit::Nuntius::JobConsumer.handle do
  # Emitted by assigment manual evaluation in classroom
  job 'CustomNotificationCreated' do |payload|
    body = payload.with_indifferent_access
    CustomNotification.notify_users_to_add!(body[:custom_notification_id], body[:uids])
  end

  job 'CustomNotificationUserAdded' do |payload|
    body = payload.with_indifferent_access
    CustomNotification.add_user_and_notify_via_email!(body[:custom_notification_id], body[:uid])
  end
end
