ActiveAdmin.register Guide do

  permit_params :name, :author_id, :description, :locale, :language_id,
                :learning, :beta, :corollary, :github_repository, :position, :path_id, :extra_code

  filter :name
  filter :description
  filter :path
  filter :learning
  filter :beta
  filter :language
  filter :path
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:learning)
    column(:beta)
    column(:path)
    column(:position)
    column(:language)
    column(:github_repository)

    actions
  end
end
 
