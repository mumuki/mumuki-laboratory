module OrganizationsControllerTemplate
  extend ActiveSupport::Concern

  included do
    before_action :set_organization!, only: [:show, :update, :edit]
    before_action :set_new_organization!, only: :create
  end

  private

  def set_new_organization!
    @organization = Organization.new organization_params
  end

  def set_organization!
    @organization = Organization.find_by! name: params[:id]
  end

  def protection_slug
    @organization&.slug
  end

  def organization_params
    params
      .require(:organization)
      .permit(:book,
              :contact_email, :name, :locale, :description,
              :logo_url, :banner_url, :open_graph_image_url, :favicon_url, :breadcrumb_image_url,
              :raise_hand_enabled, :report_issue_enabled, :forum_enabled,
              :feedback_suggestions_enabled, :public, :immersive,
              :theme_stylesheet, :extension_javascript, :terms_of_service,
              :community_link, :login_provider, :embeddable, :provider_settings,
              login_methods: [])
      .tap { |it| it.merge!(book: Book.find_by!(slug: it[:book])) if it[:book] }
  end
end
