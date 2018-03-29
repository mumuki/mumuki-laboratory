Mumukit::Nuntius::EventConsumer.handle do
  event 'UserChanged' do |payload|
    User.import_from_json! payload.deep_symbolize_keys[:user]
  end

  event 'CourseChanged' do |payload|
    Course.import_from_json! payload.deep_symbolize_keys[:course]
  end

  event 'InvitationCreated' do |payload|
    Invitation.import_from_json! payload.deep_symbolize_keys[:invitation]
  end

  event 'UpsertExam' do |body|
    Exam.import_from_json! body
  end

  event 'AssignmentManuallyEvaluated' do |payload|
    Assignment.evaluate_manually! payload.deep_symbolize_keys[:assignment]
  end

  [Book, Topic, Guide].each do |it|
    event "#{it.name}Changed" do |data|
      it.import! data[:slug]
    end
  end
end
