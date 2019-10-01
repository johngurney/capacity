class ChangeColNameInCapacitylog < ActiveRecord::Migration[5.2]
  def change
    rename_column :capacitylogs, :capacitycode, :capacity_number
    rename_column :capacitycodes, :number, :capacity_number
  end
end
