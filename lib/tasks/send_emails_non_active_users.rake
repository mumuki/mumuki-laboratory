namespace :send_emails_non_active_users do
  desc "TODO"
  task send_emails: :environment do
  	NonActiveUsersController.send_email_non_active_users
  end

end
