class AddPredictionColNames < ActiveRecord::Migration
  def change
    add_column :predictions, :minute, :integer
    add_column :predictions, :windSpeedValue, :float
    add_column :predictions, :windSpeedProb, :float
    add_column :predictions, :windDirValue, :string
    add_column :predictions, :windDirProb, :float
  end
end