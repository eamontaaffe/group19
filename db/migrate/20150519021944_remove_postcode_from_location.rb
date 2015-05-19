class RemovePostcodeFromLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :postcode, :integer
  end
end
