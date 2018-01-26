class MakeTosTypeText < ActiveRecord::Migration[4.2]
  def change
    change_column :organizations, :terms_of_service, :text
  end
end
