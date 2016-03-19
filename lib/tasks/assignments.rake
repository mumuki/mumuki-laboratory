namespace :assignments do
  task :notify_all, [:book_name] => :environment do |t, args|
    book = Book.find_by name: args[:book_name]
    book.switch!

    exercises_ids = Lesson.all.flat_map {|l| l.guide.exercises }.map(&:id)

    Assignment.where(exercise_id: exercises_ids).each do |assignment|
      EventSubscriber.notify_sync!(Event::Submission.new(assignment))
    end
  end
end
