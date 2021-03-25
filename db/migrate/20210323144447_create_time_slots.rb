class CreateTimeSlots < ActiveRecord::Migration[6.1]
  def change
    create_table :time_slots do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :start_at
      t.integer :end_at

      t.timestamps
    end
  end
end
