class AddTopicToChapter < ActiveRecord::Migration[4.2]
  def change
    add_column :chapters, :topic_id, :integer, index: true
  end
end
