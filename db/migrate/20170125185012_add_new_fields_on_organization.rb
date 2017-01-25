class AddNewFieldsOnOrganization < ActiveRecord::Migration
  def change
    change_column :organizations, :private, :boolean,  default: false

    change_table :organizations do |t|
      t.rename :private, :public
      t.text :book_ids, array: true, default: []

      t.string :terms_of_service
      t.string :locale
      t.string :theme_stylesheet_url
      t.string :extension_javascript_url
    end
  end
end
