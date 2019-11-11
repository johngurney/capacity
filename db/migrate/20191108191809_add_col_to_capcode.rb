class AddColToCapcode < ActiveRecord::Migration[5.2]
  def change
    add_column :capacitycodes, :alert, :boolean
  end
end
