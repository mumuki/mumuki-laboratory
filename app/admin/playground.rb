ActiveAdmin.register Playground do

  permit_params :author_id,
                :language_id,
                :guide_id,
                :name,
                :layout,
                :description,
                :extra_code,
                :hint,
                :locale

  filter :name
  filter :author
  filter :guide
  filter :language
  filter :locale
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:language)
    column(:guide)
    column(:layout)
    column(:submissions_count)
    column(:author)
    column(:locale)

    actions
  end
end
