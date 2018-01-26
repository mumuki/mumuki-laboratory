class RenamePrefaceToDescription < ActiveRecord::Migration[4.2]
  def change
    rename_column :books, :preface, :description
  end
end
