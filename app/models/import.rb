class Import < ActiveRecord::Base
  extend WithAsyncAction
  include WithStatus

  belongs_to :guide

  schedule_on_create ImportGuideJob

  def run_import!
    run_update! do
      import_from_json! Mumukit::Bridge::Bibliotheca.new.guide(guide.slug)
      {result: '', status: :passed}
    end
  end

  def import_from_json!(json)
    guide.import_from_json!(json)
  end
end
