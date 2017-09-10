class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :uid
      t.string :udid
      t.string :epc
      t.string :code
      t.float :x
      t.float :y
      t.references :floor, index: true

      t.timestamps
    end
  end
end
