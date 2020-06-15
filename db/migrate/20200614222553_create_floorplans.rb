class CreateFloorplans < ActiveRecord::Migration[5.2]
  def change
    create_table :floorplans do |t|
      t.string :name
      t.timestamps
    end
  end
end
