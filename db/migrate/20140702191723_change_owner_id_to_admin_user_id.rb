class ChangeOwnerIdToAdminUserId < ActiveRecord::Migration
  def change
    rename_column :customers, :owner_id, :admin_user_id
  end
end
