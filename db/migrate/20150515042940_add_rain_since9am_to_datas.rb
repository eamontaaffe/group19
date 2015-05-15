class AddRainSince9amToDatas < ActiveRecord::Migration
  def change
    add_column :data, :rain_since_9am, :float
  end
end
