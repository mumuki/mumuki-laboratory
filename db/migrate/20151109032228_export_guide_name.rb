class ExportGuideName < ActiveRecord::Migration
  def change
    Rake::Task['guides:export_all'].invoke
  end
end
