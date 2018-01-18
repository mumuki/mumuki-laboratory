namespace :users do

  task notify_reminder: :environment do
    User.where.not(last_submission_date: nil).each { |user| user.remind! }
  end

end
