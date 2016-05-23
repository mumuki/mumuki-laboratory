class AddIdToExamAuthorizations < ActiveRecord::Migration
  def change
    add_column :exam_authorizations, :id, :primary_key
  end
end
