class AddPostcodeToLocation < ActiveRecord::Migration
  def change
    add_reference :locations, :postcode, index: true, foreign_key: true
  end
end
