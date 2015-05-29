ActiveAdmin.register Exercise do

  permit_params :author_id, :language_id, :guide_id, :title, :description, :test, :extra_code, :hint, :corollary, :locale

  filter :title
  filter :author
  filter :locale
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:title)
    column(:language)
    column(:submissions_count)
    column(:author_name) { |ex| ex.author.name }
    column(:locale)

    actions
  end
end
