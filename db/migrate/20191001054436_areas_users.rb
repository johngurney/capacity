class AreasUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :areas_users, :id => false do |t|
      t.integer :area_id
      t.integer :user_id
    end
  end
end
