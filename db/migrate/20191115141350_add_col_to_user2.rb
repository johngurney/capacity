class AddColToUser2 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :alpha_order, :integer
  end
end
