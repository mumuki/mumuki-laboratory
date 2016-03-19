namespace :assignments do
  task :notify_all, [:book_name] => :environment do |t, args|
    book = Book.find_by name: args[:book_name]
    book.switch!

    exercises_ids = Lesson.all.flat_map {|l| l.guide.exercises }.map(&:id)
    assignments = Assignment.where(exercise_id: exercises_ids)

    count = assignments.count
    succeeded = unknown_student = failed = 0

    puts "We will try to send #{count} assignments, please wait..."

    assignments.each do |assignment|
      begin
        EventSubscriber.notify_sync!(Event::Submission.new(assignment))
        succeeded = succeeded + 1
      rescue RestClient::BadRequest => _
        unknown_student = unknown_student + 1
      rescue Exception => _
        failed = failed + 1
      end
    end

    puts "Finished! Of #{count} assignments, #{succeeded} succeeded, #{unknown_student} belonged to unknown students and #{failed} failed for other reasons."
  end
end
