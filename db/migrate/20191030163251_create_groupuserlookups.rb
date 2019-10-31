class CreateGroupuserlookups < ActiveRecord::Migration[5.2]
  def change
    create_table :groupuserlookups do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :selected

      t.timestamps
    end
  end
end
