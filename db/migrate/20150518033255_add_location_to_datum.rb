class AddLocationToDatum < ActiveRecord::Migration
  def change
    add_reference :data, :location, index: true, foreign_key: true
  end
end
