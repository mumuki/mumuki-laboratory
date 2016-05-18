class RenameExamUsersToExamAuthorization < ActiveRecord::Migration
  def change
    rename_table :exams_users, :exam_authorizations
  end
end
