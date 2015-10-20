class Guide

end

class Import < RepositoryOperation
  include WithFileReading

  schedule_on_create ImportGuideJob

  def run_import!
    run_update! do
      guide_json = RestClient.get("#{Rails.configuration.content_server_url}/guides/#{guide.original_id}")
      read_from_json guide_json
    end
  end

  def read_from_json(json)
    guide.update! json.except(:exercises)
    json[:exercises].each do |e|
      exercise = clazz.find_or_initialize_by(position: e[:position], guide_id: guide.id)
      exercise.assign_attributes(e)
      exercise.save
    end
  end
end
