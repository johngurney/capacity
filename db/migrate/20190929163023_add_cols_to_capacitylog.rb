class AddColsToCapacitylog < ActiveRecord::Migration[5.2]
  def change
    add_column :capacitylogs, :absent, :boolean
    add_column :capacitylogs, :return_date, :datetime
  end
end
