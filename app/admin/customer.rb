ActiveAdmin.register Customer do
  permit_params :name, :email, :phone, :address, :admin_user_id
  menu priority: 10
  filter :name
  scope_to :current_admin_user, unless: proc{ current_admin_user.super_admin? }

  controller do
    def scoped_collection
      Customer.where(admin_user: current_admin_user)
    end
    def new
      @customer = Customer.new admin_user_id: current_admin_user.id
    end
  end

  index :download_links => false do
    column :name
    column :email
    column :phone
    column :address
    column :projects do |customer|
      if customer.projects.empty?
        link_to 'Add Project', new_admin_customer_project_path(customer)
      else
        link_to customer.projects.count, admin_customer_projects_path(customer)
      end
    end
    actions
  end

  show :title => :name do |customer|
    attributes_table do
      rows :email, :phone, :address
    end
    panel("Projects") do
      table_for customer.projects do
        column :name do |project|
          link_to project.name, admin_customer_projects_path(customer)+'/'+project.id.to_s
        end
        column :buildings do |project|
          project.buildings.count
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Customer Details" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :address
      f.input :admin_user_id, as: :hidden
    end
    f.actions
  end
end
