class AddHistoryColsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :history_start_date, :date
    add_column :users, :history_end_date, :date
  end
end
