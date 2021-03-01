module WithAuthorization
  extend ActiveSupport::Concern

  def authorization_slug
    protection_slug || '_/_'
  end

  def protection_slug
    warn "protection_slug is nil, which is not probably what you want" unless @slug
    @slug
  end
end
