Mumukit::Nuntius::EventConsumer.handle do
  # Emitted by assigment manual evaluation in classroom
  event 'AssignmentManuallyEvaluated' do |payload|
    Assignment.evaluate_manually! payload.deep_symbolize_keys[:assignment]
  end

  event 'CreateMassiveNotifications' do |payload|
    body = payload.with_indifferent_access
    Notification.create_massive_notifications_for!(body[:notification], body[:uids])
  end

  event 'SendNotificationEmail' do |payload|
    Notification.notify_via_email! payload.with_indifferent_access[:notification_id]
  end
end
