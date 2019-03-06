namespace :laboratory do
  namespace :users do

    task notify_reminder: :environment do
      BATCH_SIZE = ENV['MUMUKI_JOB_BATCH_SIZE']&.to_i || 1000

      User.remindable.find_each(batch_size: BATCH_SIZE) do |user|
        user.try_remind_with_lock!
      end if ApplicationMailer.environment_variables_set?
    end
  end
end
