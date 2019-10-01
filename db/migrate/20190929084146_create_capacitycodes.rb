class CreateCapacitycodes < ActiveRecord::Migration[5.2]
  def change
    create_table :capacitycodes do |t|
      t.string :text
      t.integer :number

      t.timestamps
    end
  end
end
