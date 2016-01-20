class TenantSubscriber < EventSubscriber

  def do_request(event, path)
    RestClient.post("#{tenant_url}/#{path}", event, content_type: :json)
  end

  def tenant_url
    url.split('//').tap { |array| array[1] = "#{Apartment::Tenant.current}.#{array[1]}" }.join('//')

  end

end
