class RemovePrecipFromData < ActiveRecord::Migration
  def change
    remove_column :data, :precip
  end
end
