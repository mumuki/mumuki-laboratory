module Laboratory
  module Event
    class OrganizationChanged
      def self.execute!(payload)
        Organization.update_from_json! payload.deep_symbolize_keys[:organization]
      end
    end
  end
end
