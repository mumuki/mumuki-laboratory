module Laboratory::Event
  define_handler :OrganizationCreated do |payload|
    Organization.create_from_json! payload.deep_symbolize_keys[:organization]
  end

  define_handler :OrganizationChanged do |payload|
    Organization.update_from_json! payload.deep_symbolize_keys[:organization]
  end
end
