Mumukit::Nuntius::EventConsumer.handle do
  def clean_payload(payload, key)
    payload.deep_symbolize_keys[key].except(:created_at, :updated_at)
  end

  event 'UserChanged' do |payload|
    User.import_from_json! clean_payload(payload, :user)
  end

  event 'OrganizationCreated' do |payload|
    Organization.create_from_json! clean_payload(payload, :organization)
  end

  event 'OrganizationChanged' do |payload|
    Organization.update_from_json! clean_payload(payload, :organization)
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
