class AddTagToProject < ActiveRecord::Migration
  def change
    add_reference :projects, :tag, index: true
  end
end
