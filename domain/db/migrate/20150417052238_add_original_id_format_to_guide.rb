class AddOriginalIdFormatToGuide < ActiveRecord::Migration[4.2]
  def change
    add_column :guides, :original_id_format, :string, default: '%05d', null: false
  end
end
