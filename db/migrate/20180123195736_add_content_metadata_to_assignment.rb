class AddContentMetadataToAssignment < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :content_metadata, :string
  end
end
