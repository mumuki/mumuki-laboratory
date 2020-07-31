module WithAuthorization
  extend ActiveSupport::Concern

  def authorize_janitor!
    authorize! :janitor
  end

  def authorize_admin!
    authorize! :admin
  end

  def authorize_owner!
    authorize! :owner
  end

  def authorize_moderator!
    authorize! :moderator
  end

  def authorization_slug
    protection_slug || '_/_'
  end

  def protection_slug
    @slug
  end
end
