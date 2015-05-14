ActiveAdmin.register StartingPoint do

  permit_params :category_id, :guide_id, :language_id

  filter :category
  filter :guide
  filter :language
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:category)
    column(:guide)
    column(:language)

    actions
  end
end

