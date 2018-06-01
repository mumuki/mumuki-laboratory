namespace :users do

  task notify_reminder: :environment do
    if ApplicationMailer.environment_variables_set?
      User.where.not(accepts_reminders: false).each { |user| user.remind! }
    end
  end

end
