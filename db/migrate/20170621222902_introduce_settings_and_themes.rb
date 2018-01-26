class IntroduceSettingsAndThemes < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :settings, :text, default: "{}", null: false
    add_column :organizations, :theme, :text, default: "{}", null: false
    add_column :organizations, :profile, :text, default: "{}", null: false

    Organization.all.each do |organization|
      organization.profile = Mumukit::Platform::Organization::Profile.new(
        logo_url: organization[:logo_url],
        locale: organization[:locale],
        description: organization[:description],
        contact_email: organization[:contact_email],
        terms_of_service: organization[:terms_of_service],
        community_link: organization[:community_link]
      )
      organization.settings = Mumukit::Platform::Organization::Settings.new(
        login_methods: organization[:login_methods],
        raise_hand_enabled: organization[:raise_hand_enabled],
        public: organization[:public]
      )
      organization.theme = Mumukit::Platform::Organization::Theme.new(
        theme_stylesheet_url: organization[:theme_stylesheet_url],
        extension_javascript_url: organization[:extension_javascript_url]
      )
      organization.save!
    end

    remove_column :organizations, :login_methods
    remove_column :organizations, :raise_hand_enabled
    remove_column :organizations, :public
    remove_column :organizations, :locale
    remove_column :organizations, :logo_url
    remove_column :organizations, :theme_stylesheet_url
    remove_column :organizations, :extension_javascript_url
    remove_column :organizations, :community_link
    remove_column :organizations, :description
    remove_column :organizations, :contact_email
    remove_column :organizations, :terms_of_service
  end
end
