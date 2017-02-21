module Laboratory::Event
  define_handler :UpsertExam do |body|
    Exam.import_from_json! body.except(:social_ids, :sender)
  end
end
