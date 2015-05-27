require 'rufus-scheduler'

updater = Rufus::Scheduler.new

# BOM update every 10 minutes
updater.every '10m', :first_in => '10s' do
  Location.all.each do |loc|
    loc.new_BOMreading
  end
end

=begin
updater.every '10m', :first_in => '1m' do
  Location.all.each do |location|
    location.new_location_predictions
  end
end
=end

# Staggered updates for FIO, 40 min blocks
group = (Location.all.size/6).ceil
# 1st batch of updates
updater.every '40m', :first_in => '5m' do
  Location.all[0..group].each do |loc|
    loc.new_FIOreading
  end
end
# 2nd batch of updates
updater.every '40m', :first_in => '10m' do
  Location.all[(group+1)..(2*group)].each do |loc|
    loc.new_FIOreading
  end
end
# etc ...
updater.every '40m', :first_in => '15m' do
  Location.all[(2*group+1)..(3*group)].each do |loc|
    loc.new_FIOreading
  end
end
updater.every '40m', :first_in => '20m' do
  Location.all[(3*group+1)..(4*group)].each do |loc|
    loc.new_FIOreading
  end
end
updater.every '40m', :first_in => '25m' do
  Location.all[(4*group+1)..(5*group)].each do |loc|
    loc.new_FIOreading
  end
end
updater.every '40m', :first_in => '30m' do
  Location.all[(5*group+1)..(6*group)].each do |loc|
    loc.new_FIOreading
  end
end
updater.every '40m', :first_in => '35m' do
  Location.all[(6*group+1)..(Location.all.size)].each do |loc|
    loc.new_FIOreading
  end
end