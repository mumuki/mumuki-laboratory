Mumukit::Nuntius::EventConsumer.handle do
  event 'UserChanged' do |payload|
    User.import_from_json! payload.deep_symbolize_keys[:user]
  end

  ['OrganizationCreated', 'OrganizationChanged'].each do |it|
    event it do |payload|
      Organization.import_from_json! payload['organization']
    end
  end

  event 'InvitationCreated' do |payload|
    Invitation.import_from_json! payload.deep_symbolize_keys[:invitation]
  end

  event 'UpsertExam' do |body|
    Exam.import_from_json! body
  end

  [Book, Topic, Guide].each do |it|
    event "#{it.name}Changed" do |data|
      it.import! data[:slug]
    end
  end
end
