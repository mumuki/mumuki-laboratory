class ImportGuideJob < ActiveRecordJob

  def perform_with_connection(import_id)
    ::Import.find(import_id).run_import!
  end
end