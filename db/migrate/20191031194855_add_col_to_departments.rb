class AddColToDepartments < ActiveRecord::Migration[5.2]
  def change
    add_column :departments, :group_id, :integer
  end
end
