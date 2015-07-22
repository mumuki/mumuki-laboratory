namespace :submissions do
  task notify_all: :environment do
    Submission.all.each do |submission|
      EventSubscriber.notify_submission!(submission)
    end
  end
end
