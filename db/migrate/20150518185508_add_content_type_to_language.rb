class AddContentTypeToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :output_content_type, :integer, default: 0
  end
end
