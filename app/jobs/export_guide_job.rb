class ImportGuideJob < ActiveRecordJob
  def perform_with_connection(export_id)
    #::Export.find(export_id).run_export!
  end
end
