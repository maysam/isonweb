class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings do |t|
      t.text :data
      t.references :tag, index: true

      t.timestamps
    end
  end
end
