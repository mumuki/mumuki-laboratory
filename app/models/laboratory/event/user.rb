module Laboratory::Event
  define_handler :UserChanged do |payload|
    User.import_from_json! payload.deep_symbolize_keys[:user]
  end
end
