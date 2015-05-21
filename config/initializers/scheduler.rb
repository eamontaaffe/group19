require 'rufus-scheduler'

updater = Rufus::Scheduler.new

updater.every '10m', :first => :now do
  Location.all.each do |loc|
    loc.new_BOMreading
  end
end

=begin
updater.every('30m') do
  Location.all.each do |loc|
    loc.new_FIOreading
  end
end
=end
