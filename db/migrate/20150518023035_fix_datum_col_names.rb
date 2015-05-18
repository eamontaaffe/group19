class FixDatumColNames < ActiveRecord::Migration
  def change
    rename_column :data, :wind_direction, :windDirection
    rename_column :data, :wind_speed, :windSpeed
    rename_column :data, :rain_since_9am, :rainSince9am
    rename_column :predictions, :rain_value, :rainValue
    rename_column :predictions, :rain_prob, :rainProb
    rename_column :predictions, :temp_value, :tempValue
    rename_column :predictions, :temp_prob, :tempProb
  end
end
