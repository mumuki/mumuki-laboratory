ActiveAdmin.register ChapterGuide do

  permit_params :chapter_id, :guide_id, :number

  filter :chapter
  filter :guide
  filter :number
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:chapter)
    column(:guide)
    column(:number)

    actions
  end

  form do |f|
    inputs :chapter, :guide, :number
    actions
  end
end

