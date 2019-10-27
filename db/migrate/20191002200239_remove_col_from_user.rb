class RemoveColFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :location
    remove_column :users, :department

  end
end
