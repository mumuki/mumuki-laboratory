module ApplicationRoot
  def self.url_for(subdomain, path)
    URI.join(subdominated(subdomain), path).to_s
  end

  def self.uri
    URI(Rails.configuration.base_url)
  end

  def self.subdominated(subdomain)
    uri.subdominate(subdomain)
  end

  def self.domain
    uri.domain
  end
end
