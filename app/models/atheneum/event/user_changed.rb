module Atheneum
  module Event
    class UserChanged
      def self.execute!(payload)
        User.import_from_json! body payload.deep_symbolize_keys[:user]
      end
    end
  end
end
