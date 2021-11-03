class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.string :device_id
      t.string :device_name

      t.timestamps
    end
  end
end
