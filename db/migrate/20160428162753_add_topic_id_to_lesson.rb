class AddTopicIdToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :topic_id, :integer, index: true
  end
end
