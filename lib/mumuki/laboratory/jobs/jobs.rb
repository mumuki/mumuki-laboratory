Mumukit::Nuntius::JobConsumer.handle do
  # Emitted by assigment manual evaluation in classroom
  job 'MassiveJobCreated' do |payload|
    body = payload.with_indifferent_access
    MassiveJob.notify_users_to_add!(body[:massive_job_id], body[:uids])
  end

  job 'UserAddedMassiveJob' do |payload|
    body = payload.with_indifferent_access
    MassiveJob.process!(body[:massive_job_id], body[:uid])
  end
end
