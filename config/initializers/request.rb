require 'rack/request'

module Rack
  class Request
    def first_subdomain_after(domain)
      subdomain_after(domain)&.first
    end

    def subdomain_after(domain)
      raise 'no host set' unless host
      raise 'set hostname first!' if /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host)
      return nil if host == 'localhost'
      domain_parts = domain.split('.')
      (host.split('.') - domain_parts)
    end

    def empty_subdomain_after?(domain)
      first_subdomain_after(domain).blank?
    end
  end
end
