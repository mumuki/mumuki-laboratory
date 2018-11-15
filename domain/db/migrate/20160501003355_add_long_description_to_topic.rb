class AddLongDescriptionToTopic < ActiveRecord::Migration[4.2]
  def change
    add_column :topics, :long_description, :text
  end
end
