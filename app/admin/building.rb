ActiveAdmin.register Building do
  permit_params :name, :project_id
  scope_to :current_admin_user, association_method: :all_buildings, unless: proc{ current_admin_user.super_admin? }

  menu priority: 30

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
      f.input :project_id, as: :select, collection: current_admin_user.projects.pluck(:name, :id)
    end
    f.actions
  end

end
