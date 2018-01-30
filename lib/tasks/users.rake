namespace :users do

  task notify_reminder: :environment do
    if ApplicationMailer.environment_variables_set?
      User.where.not(last_submission_date: nil, accepts_reminders: false).each { |user| user.remind! }
    end
  end

end
