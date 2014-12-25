class ImportGuideJob < ActiveRecordJob

  def perform_with_connection(guide_id)
    ::Guide.find(guide_id).import!
  end
end