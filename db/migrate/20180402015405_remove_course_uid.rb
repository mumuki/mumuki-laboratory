class RemoveCourseUid < ActiveRecord::Migration[5.1]
  def change
    remove_column :courses, :uid
  end
end
