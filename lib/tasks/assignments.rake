namespace :assignments do
  task notify_all: :environment do
    Assignment.all.each do |assignment|
      EventSubscriber.notify_sync!(Event::Submission.new(assignment))
    end
  end
end
