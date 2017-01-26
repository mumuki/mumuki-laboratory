class ApplicationRoot

  attr_accessor :base_url

  def initialize(base_url)
    @base_url = base_url
  end

  def url_for(subdomain, path)
    URI.join(subdominated(subdomain), path).to_s
  end

  def uri
    URI(@base_url)
  end

  def subdominated(subdomain)
    uri.subdominate(subdomain)
  end

  def domain
    uri.domain
  end

  class << self

    def laboratory
      new Rails.configuration.base_url
    end

    def classroom
      new Rails.configuration.classroom_url
    end

    def office
      new Rails.configuration.office_url
    end

    def bibliotheca
      new Rails.configuration.bibliotheca_url
    end
  end

end
