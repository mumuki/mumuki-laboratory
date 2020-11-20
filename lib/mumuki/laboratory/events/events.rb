Mumukit::Nuntius::EventConsumer.handle do

  # Emitted by assigment manual evaluation in classroom
  event 'AssignmentManuallyEvaluated' do |payload|
    Assignment.evaluate_manually! payload.deep_symbolize_keys[:assignment]
  end

  [Book, Topic, Guide].each do |it|
    event "#{it.name}Changed" do |data|
      Mumukit::Sync::Syncer.new(
        Mumukit::Sync::Store::Bibliotheca.new(
          Mumukit::Platform.bibliotheca_bridge)).locate_and_import! it, data[:slug]
    end
  end
end
