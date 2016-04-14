ActiveAdmin.register EventSubscriber do

  permit_params :enabled

  filter :enabled

  index do
    column :enabled

    actions
  end

  controller do
    def scoped_collection
      EventSubscriber.unscoped.where(type: 'EventSubscriber')
    end
  end

end
