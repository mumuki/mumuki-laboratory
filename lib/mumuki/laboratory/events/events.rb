Mumukit::Nuntius::EventConsumer.handle do
  # Emitted by assigment manual evaluation in classroom
  event 'AssignmentManuallyEvaluated' do |payload|
    Assignment.evaluate_manually! payload.deep_symbolize_keys[:assignment]
  end
end
