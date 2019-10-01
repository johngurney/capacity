class CreateCapacitylogs < ActiveRecord::Migration[5.2]
  def change
    create_table :capacitylogs do |t|
      t.integer :user_id
      t.string :comment
      t.integer :capacitycode

      t.timestamps
    end
  end
end
