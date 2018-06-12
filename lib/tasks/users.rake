namespace :users do

  task notify_reminder: :environment do
    BATCH_SIZE = ENV["MUMUKI_JOB_BATCH_SIZE"]&.to_i || 1000

    if ApplicationMailer.environment_variables_set?
      User
        .where(accepts_reminders: true)
        .find_each(batch_size: BATCH_SIZE) do |user|
          user.with_lock do
            user.remind!
          end
      end
    end
  end

end
