class RenameTagFields < ActiveRecord::Migration
  def change
    rename_column :tags, :udid, :uid
    add_column :tags, :status, :string
    add_column :tags, :interval, :integer
  end
end
