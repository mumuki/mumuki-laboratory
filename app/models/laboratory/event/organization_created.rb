module Laboratory
  module Event
    class OrganizationCreated
      def self.execute!(payload)
        Organization.create_from_json! payload.deep_symbolize_keys[:organization]
      end
    end
  end
end
