module Atheneum
  module Event
    class UserChanged
      def self.execute!(payload, _action)
        User.import_from_json! payload.deep_symbolize_keys[:user]
      end
    end
  end
end
