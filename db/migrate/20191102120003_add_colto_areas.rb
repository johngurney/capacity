class AddColtoAreas < ActiveRecord::Migration[5.2]
  def change
    add_column :areas, :group_id, :integer
  end
end
