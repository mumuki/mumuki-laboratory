namespace :users do

  task notify_reminder: :environment do
    BATCH_SIZE = ENV['MUMUKI_JOB_BATCH_SIZE']&.to_i || 1000

    if ApplicationMailer.environment_variables_set?
      User
        .where('accepts_reminders and (last_submission_date < ? or last_submission_date is null)', Rails.configuration.remainder_frequency.days.ago)
        .find_each(batch_size: BATCH_SIZE) do |user|
          user.with_lock('for update nowait') { user.remind! } rescue nil
        end
      end
    end
  end

end
