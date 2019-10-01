class CreateLoginlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :loginlogs do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
  end
end
