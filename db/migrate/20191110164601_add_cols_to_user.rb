class AddColsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_manager, :boolean
    add_column :users, :leaving_date, :date
  end
end
