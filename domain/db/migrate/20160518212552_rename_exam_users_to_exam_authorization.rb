class RenameExamUsersToExamAuthorization < ActiveRecord::Migration[4.2]
  def change
    rename_table :exams_users, :exam_authorizations
  end
end
