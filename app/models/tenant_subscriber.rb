class TenantSubscriber < EventSubscriber

  def get_url
    url.split('//').tap { |array| array[1] = "#{Apartment::Tenant.current}.#{array[1]}" }.join('//')
  end

end
