class Import < ActiveRecord::Base
  extend WithAsyncAction
  include WithStatus

  belongs_to :guide

  schedule_on_create ImportGuideJob

  def run_import!
    run_update! do
      guide_json = JSON.parse RestClient.get(guide.url)
      read_from_json guide_json
    end
  end

  def read_from_json(json)
    guide.update! json.except('exercises', 'language', 'original_id_format', 'github_repository')
    guide.update! language: Language.find_by_name(json['language'])

    json["exercises"].each do |e  |
      exercise = Exercise.class_for(e['type']).find_or_initialize_by(position: e['position'], guide_id: guide.id)
      exercise.assign_attributes(e)
      exercise.language = guide.language
      exercise.locale = guide.locale
      exercise.save
    end
  end
end
