class AddCustomEditorAssetsToLanguage < ActiveRecord::Migration[5.1]
  def change
    change_table :languages do |t|
      t.string :custom_editor_js_urls, array: true, default: []
      t.string :custom_editor_html_urls, array: true, default: []
      t.string :custom_editor_css_urls, array: true, default: []
    end
  end
end
