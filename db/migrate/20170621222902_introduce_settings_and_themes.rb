class IntroduceSettingsAndThemes < ActiveRecord::Migration
  def change
    add_column :organizations, :settings,  :text, default: "{}", null: false
    add_column :organizations, :theme,     :text, default: "{}", null: false
    add_column :organizations, :community,   :text, default: "{}", null: false

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
