class AddIdColsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :location_id, :integer
    add_column :users, :department_id, :integer
  end
end
