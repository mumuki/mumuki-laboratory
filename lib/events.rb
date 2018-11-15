Mumukit::Nuntius::EventConsumer.handle do

  # Emitted by user registration and modification in classroom
  event 'UserChanged' do |payload|
    User.import_from_resource_h! payload.deep_symbolize_keys[:user]
  end

  # Emitted by course creation of courses in classroom
  event 'CourseChanged' do |payload|
    Course.import_from_resource_h! payload.deep_symbolize_keys[:course]
  end

  # Emitted by invitation creation in classroom
  event 'InvitationCreated' do |payload|
    Invitation.import_from_resource_h! payload.deep_symbolize_keys[:invitation]
  end

  # Emitted by exam creation and modification in classroom
  event 'UpsertExam' do |body|
    Exam.import_from_resource_h! body
  end

  # Emitted by assigment manual evaluation in classroom
  event 'AssignmentManuallyEvaluated' do |payload|
    Assignment.evaluate_manually! payload.deep_symbolize_keys[:assignment]
  end

  [Book, Topic, Guide].each do |it|
    event "#{it.name}Changed" do |data|
      slug = data[:slug]
      item = it.find_or_initialize_by(slug: slug)

      Mumukit::Sync::Syncer.new(
        Mumukit::Sync::Store::Bibliotheca.new(
          Mumukit::Platform.bibliotheca_bridge)).import! item
    end
  end
end
