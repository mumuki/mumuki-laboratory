namespace :assignments do
  task :notify_all, [:book_name, :date_since] => :select_book do |t, args|
    args.with_defaults(date_since: '2014-01-01')
    exercises_ids = Lesson.all.flat_map {|l| l.guide.exercises }.map(&:id)

    notify Assignment.where(exercise_id: exercises_ids).where('updated_at >= ?', Date.parse(args[:date_since]))
  end

  task :notify_user, [:book_name, :user_uid] => :select_book do |t, args|
    user = User.find_by(uid: args[:user_uid])
    puts "Found user #{user.name}."

    notify Assignment.where(submitter_id: user.id)
  end

  def notify(assignments)
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

  # This task should not be called directly (because it "does nothing"), it's just a prerrequisite for the others.
  task :select_book, [:book_name] => :environment do |t, args|
    book = Book.find_by name: args[:book_name]
    book.switch!
  end
end
