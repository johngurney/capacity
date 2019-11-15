class AddColsToUser1 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name_encrypted, :string
    add_column :users, :last_name_encrypted, :string
    add_column :users, :email_encrypted, :string
  end
end
