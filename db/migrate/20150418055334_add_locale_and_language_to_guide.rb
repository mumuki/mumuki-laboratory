class AddLocaleAndLanguageToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :locale, :string, index: true
    add_column :guides, :language_id, :integer, index: true
  end
end
