module Atheneum
  module Event
    class UserChanged
      def self.execute!(payload)
        body = payload.deep_symbolize_keys[:user]
        body[:name] = "#{body.delete(:first_name)} #{body.delete(:last_name)}"
        user = User.where('uid = ? or email = ?', body[:uid], body[:uid]).first_or_create(body.except(:permissions, :id))
        user.set_permissions! body[:permissions]
      end
    end
  end
end
