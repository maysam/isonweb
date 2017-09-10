class AddSuperAdminToAdminUser < ActiveRecord::Migration
  def migrate(direction)
    super
    # Create a default user
    AdminUser.update_all(super_admin: true) if direction == :up
  end

  def change
    add_column :admin_users, :super_admin, :bool
  end
end
