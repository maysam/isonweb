class ChangeTags < ActiveRecord::Migration
  def change
    rename_column :tags, :uid, :name
    add_column :tags, :active, :integer
  end
end
