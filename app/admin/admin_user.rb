ActiveAdmin.register AdminUser do
  menu if: proc{ current_admin_user.super_admin? }, priority: 10
  scope_to :current_admin_user, association_method: :all_admin_users, unless: proc{ current_admin_user.super_admin? }

  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :super_admin
    actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show title: :email do |f|
    attributes_table do
      rows :email, :last_sign_in_at
    end
  end
end
