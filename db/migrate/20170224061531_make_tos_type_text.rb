class MakeTosTypeText < ActiveRecord::Migration
  def change
    change_column :organizations, :terms_of_service, :text
  end
end
