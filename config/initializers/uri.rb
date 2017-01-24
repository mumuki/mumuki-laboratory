class URI::HTTP
  def subdominate(subdomain)
    if host.start_with? 'www.'
      new_host = host.gsub('www.', "www.#{subdomain}.")
    else
      new_host = "#{subdomain}.#{host}"
    end
    URI::HTTP.build(scheme: scheme,
                    host: new_host,
                    path: path,
                    query: query,
                    port: port)
  end
end

