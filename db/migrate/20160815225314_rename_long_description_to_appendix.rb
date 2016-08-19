class RenameLongDescriptionToAppendix < ActiveRecord::Migration
  def change
    rename_column :topics, :long_description, :appendix
  end
end
