module Rack
  class Request
    def empty_subdomain?
      first_subdomain.blank?
    end
  end
end
