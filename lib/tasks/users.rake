namespace :users do

  task notify_reminder: :environment do
    if ApplicationMailer.environment_variables_set?
      User.where(accepts_reminders: true).each { |user| user.remind! }
    end
  end

end
