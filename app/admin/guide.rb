ActiveAdmin.register Guide do

  permit_params :name, :description, :locale, :learning, :corollary, :github_repository, :position, :path_id, :extra_code

  filter :name
  filter :description
  filter :path
  filter :learning
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:learning)
    column(:path)
    column(:position)
    column(:description)
    column(:github_repository)

    actions
  end
end
