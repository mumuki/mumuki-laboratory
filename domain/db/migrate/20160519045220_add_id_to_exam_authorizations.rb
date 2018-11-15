class AddIdToExamAuthorizations < ActiveRecord::Migration[4.2]
  def change
    add_column :exam_authorizations, :id, :primary_key
  end
end
