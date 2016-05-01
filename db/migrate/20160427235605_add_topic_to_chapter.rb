class AddTopicToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :topic_id, :integer, index: true
  end
end
