class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.float :rain_value
      t.float :rain_prob
      t.float :temp_value
      t.float :temp_prob

      t.timestamps null: false
    end
  end
end
