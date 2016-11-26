class URI::HTTP
  def add_subdomain(subdomain)
    if host.start_with? 'www.'
      new_host = host.gsub('www.', "www.#{subdomain}.")
    else
      new_host = "#{subdomain}.#{host}"
    end
    URI::HTTP.build(scheme: scheme,
                    host: new_host,
                    path: path,
                    query: query)
  end
end


class String
  def subdominate(subdomain)
    URI(self).add_subdomain(subdomain).to_s
  end
end
