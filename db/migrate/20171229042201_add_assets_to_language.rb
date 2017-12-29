class AddAssetsToLanguage < ActiveRecord::Migration[5.1]
  def change
    change_table :languages do |t|
      t.string :assets_js, array: true, default: []
      t.string :assets_html, array: true, default: []
      t.string :assets_css, array: true, default: []
    end
  end
end
