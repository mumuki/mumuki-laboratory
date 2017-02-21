Mumukit::Nuntius::EventConsumer.handle do
  event :UserChanged do |payload|
    User.import_from_json! payload.deep_symbolize_keys[:user]
  end

  event :OrganizationCreated do |payload|
    Organization.create_from_json! payload.deep_symbolize_keys[:organization]
  end

  event :OrganizationChanged do |payload|
    Organization.update_from_json! payload.deep_symbolize_keys[:organization]
  end

  event :UpsertExam do |body|
    Exam.import_from_json! body
  end

  [Book, Topic, Guide].each do |it|
    event "#{it.name}Changed" do |data|
      it.import! data[:slug]
    end
  end
end
