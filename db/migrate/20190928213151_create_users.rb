class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name_string
      t.string :user_type
      t.string :location
      t.string :position
      t.integer :capacity_status
      t.string :department

      t.timestamps
    end
  end
end
