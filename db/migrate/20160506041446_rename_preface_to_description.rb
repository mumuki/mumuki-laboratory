class RenamePrefaceToDescription < ActiveRecord::Migration
  def change
    rename_column :books, :preface, :description
  end
end
