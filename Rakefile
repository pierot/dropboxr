task :default => :run

###############################################################################

desc 'Run app'
task :run do 
  system "rackup -s thin"
end

###############################################################################

desc 'Cron tasks'
task :cron do
  puts "Cron. Rebuilding galleries. #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}"
  
  require './app/app'
  
  include DropboxrHelpers
  
  all_fine, extra_info = build_galleries
  
  body = extra_info.to_s
  subject = all_fine ? "Cron Executed!" : "Cron Failed!"
end
