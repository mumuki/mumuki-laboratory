class Import < ActiveRecord::Base
  extend WithAsyncAction
  include WithStatus

  belongs_to :guide

  schedule_on_create ImportGuideJob

  def run_import!
    run_update! do
      guide_json = JSON.parse RestClient.get(guide.url)
      read_from_json guide_json
      {result: '', status: :passed}
    end
  end

  def read_from_json(json)
    guide.assign_attributes json.except('exercises', 'language', 'original_id_format', 'github_repository')
    guide.language = Language.for_name(json['language'])
    guide.save!

    json['exercises'].each_with_index do |e, i|
      position = i + 1
      exercise = Exercise.class_for(e['type']).find_or_initialize_by(position: position, guide_id: guide.id)
      exercise.position = position
      exercise.assign_attributes(e.except('type'))
      exercise.language = guide.language
      exercise.locale = guide.locale
      exercise.save!
    end
  end
end
