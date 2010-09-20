task :cron => :environment do
 if Time.now.hour % 4 == 0 # run every four hours
   puts "Gathering Dropbox data"
 end
end