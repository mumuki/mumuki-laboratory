class AddIdFormatBack < ActiveRecord::Migration[5.1]
  def change
    add_column :guides, :id_format, :string, default: '%05d'
  end
end
