class AddTopicIdToLesson < ActiveRecord::Migration[4.2]
  def change
    add_column :lessons, :topic_id, :integer, index: true
  end
end
