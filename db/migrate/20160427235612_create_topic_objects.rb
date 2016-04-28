class CreateTopicObjects < ActiveRecord::Migration
  def change
    Chapter.all.each do |it|
      topic = Topic.create! name: it.name, description: it.description, locale: it.locale
      it.topic = topic
    end
  end
end
