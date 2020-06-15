class AddProjectToFloorplan < ActiveRecord::Migration[5.2]
  def change
    add_reference :floorplans, :project, foreign_key: true
  end
end
