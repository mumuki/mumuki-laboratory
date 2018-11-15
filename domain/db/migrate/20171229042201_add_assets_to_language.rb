class AddAssetsToLanguage < ActiveRecord::Migration[5.1]
  def change
    change_table :languages do |t|
      t.string :assets_js_urls, array: true, default: []
      t.string :assets_html_urls, array: true, default: []
      t.string :assets_css_urls, array: true, default: []
    end
  end
end
