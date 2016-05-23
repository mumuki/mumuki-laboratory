class AddUserStartDataInExam < ActiveRecord::Migration
  def change
    add_column :exam_authorizations, :started, :boolean, default: false
    add_column :exam_authorizations, :started_at, :datetime
  end
end
