namespace :assignments do
  task :notify_all, [:organization_name, :date_since] => :select_organization do |t, args|
    args.with_defaults(date_since: '2014-01-01')
    Organization.current.notify_recent_assignments! Date.parse(args[:date_since])
  end

  task :notify_user, [:organization_name, :user_uid] => :select_organization do |t, args|
    user = User.find_by(uid: args[:user_uid])
    puts "Found user #{user.name}."

    Organization.current.notify_assignments_by! user
  end

  task :notify_recent, [:organization_name] => :select_organization do |t, args|
    Organization
      .current
      .assignments
      .where(submitter: User.where(last_organization: Organization.current))
      .where('assignments.created_at > ?', 1.month.ago)
      .each { |it| Event::Submission.new(it).notify! }
  end

  # This task should not be called directly (because it "does nothing"), it's just a prerrequisite for the others.
  task :select_organization, [:organization_name] => :environment do |t, args|
    Organization.find_by!(name: args[:organization_name]).switch!
  end
end
