class AddLocationToPrediction < ActiveRecord::Migration
  def change
    add_reference :predictions, :location, index: true, foreign_key: true
  end
end
