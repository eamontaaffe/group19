namespace :db do
  desc "TODO"
  task update_predictions: :environment do
    Location.all.each do |location|
      begin
      location.new_location_predictions
    rescue Exception
        puts "========================================================="
        puts "IRREGULAR MATRIX EXCEPTION"
        puts "========================================================="
      end
    end
  end

end
