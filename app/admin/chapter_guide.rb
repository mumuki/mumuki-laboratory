ActiveAdmin.register ChapterGuide do

  permit_params :path_id, :guide_id, :position

  filter :path
  filter :guide
  filter :position
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:path)
    column(:guide)
    column(:position)

    actions
  end
end

