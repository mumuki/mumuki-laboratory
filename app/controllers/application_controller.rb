class ApplicationController < ActionController::Base
  include Authentication
  include Pagination

  before_action :set_locale

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user?,
                :current_user_id,
                :current_user_path,
                :login_github_path, :login_facebook_path,
                :login_anchor,
                :restricted_to_author, :restricted_to_current_user,
                :restricted_to_other_user

  def set_locale
    I18n.locale = subdomain_locale || params[:locale] ||  I18n.default_locale
  end

  def default_url_options
    subdomain_locale ? {} : { locale: I18n.locale }
  end

  def subdomain_locale
    unless @subdomain_locale
      parsed_locale = request.subdomains.first
      @subdomain_locale = I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    end
    @subdomain_locale
  end

end
