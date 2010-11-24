require 'pony'

task :default => :build

desc 'Maintain galleries'
task :cron do
  puts "Building galleries. #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}"
  
  Pony.mail :to => 'pieter@wellconsidered.be',
            :from => 'info@dropboxr',
            :subject => 'Cron executed!'
end