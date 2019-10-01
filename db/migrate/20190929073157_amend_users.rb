class AmendUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :last_name_string, :last_name
    add_column :users, :telephone, :string
    add_column :users, :email, :string
  end
end
