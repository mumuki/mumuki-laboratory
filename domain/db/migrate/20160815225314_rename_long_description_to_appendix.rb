class RenameLongDescriptionToAppendix < ActiveRecord::Migration[4.2]
  def change
    rename_column :topics, :long_description, :appendix
  end
end
