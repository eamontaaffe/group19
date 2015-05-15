class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.float :precip
      t.string :wind_direction
      t.float :wind_speed

      t.timestamps null: false
    end
  end
end
