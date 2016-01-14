ActiveAdmin.register ChapterGuide do

  permit_params :chapter_id, :guide_id, :position

  filter :chapter
  filter :guide
  filter :position
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:chapter)
    column(:guide)
    column(:position)

    actions
  end

  form do |f|
    inputs :chapter, :guide, :position
    actions
  end
end

