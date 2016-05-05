class AddLongDescriptionToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :long_description, :text
  end
end
