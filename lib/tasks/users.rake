namespace :users do
  desc "TODO"
  task update_last_submission_date: :environment do
    User.all.each do |user|
      unless user.last_submission_date
        user.update!(last_submission_date: user.submissions.last.created_at)
      end
    end
  end
end
