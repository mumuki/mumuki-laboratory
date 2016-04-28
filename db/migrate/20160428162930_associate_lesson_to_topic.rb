class AssociateLessonToTopic < ActiveRecord::Migration
  def change
    Lesson.all.each do |it|
      it.topic = it.chapter.topic
    end
  end
end
