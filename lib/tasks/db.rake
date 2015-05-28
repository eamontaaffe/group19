namespace :db do
  desc "TODO"
  task update_predictions: :environment do
    Location.all.each do |loc|
    
      puts loc.station
      loc.new_location_predictions

    end
  end

end
