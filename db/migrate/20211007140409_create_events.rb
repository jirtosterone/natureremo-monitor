class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :device, null: false, foreign_key: true
      t.timestamp :event_datetime
      t.float :temparature
      t.float :humidity
      t.float :illumination
      t.float :movement

      t.timestamps
    end
  end
end
