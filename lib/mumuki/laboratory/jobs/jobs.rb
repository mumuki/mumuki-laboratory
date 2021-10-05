Mumukit::Nuntius::JobConsumer.handle do
  # Emitted by assigment manual evaluation in classroom
  job 'MassiveJobCreated' do |payload|
    body = payload.with_indifferent_access
    MassiveJob.find(body[:massive_job_id]).notify_users_to_add!(body[:uids])
  end

  job 'UserAddedMassiveJob' do |payload|
    body = payload.with_indifferent_access
    MassiveJob.find(body[:massive_job_id]).process!(body[:uid])
  end
end
