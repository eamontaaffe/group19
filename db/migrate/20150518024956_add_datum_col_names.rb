class AddDatumColNames < ActiveRecord::Migration
  def change
    add_column :data, :source, :string
    add_column :data, :obsTime, :string
    add_column :data, :temp, :float
    add_column :data, :dewPoint, :float
    add_column :data, :wetBulb, :float
    add_column :data, :humidity, :float
    add_column :data, :pressure, :float
    add_column :data, :windBearing, :float
    add_column :data, :precipIntense, :float
    add_column :data, :precipProb, :float
    add_column :data, :condition, :string
    add_column :data, :cloudCover, :float
  end
end
