class RecalculateSlugs < ActiveRecord::Migration
  def self.up
    Rake::Task['slugs:update_for_exercises'].invoke
    Rake::Task['slugs:update_for_guides'].invoke
  end
end
