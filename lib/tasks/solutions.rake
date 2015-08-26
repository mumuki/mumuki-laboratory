namespace :solutions do
  task notify_all: :environment do
    Solution.all.each do |solution|
      EventSubscriber.notify_sync!(Event::Submission.new(solution))
    end
  end
end
