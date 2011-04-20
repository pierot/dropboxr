require 'pony'

task :default => :run

desc 'Run app'
task :run do 
  system "rackup -s thin"
end

desc 'Maintain galleries'
task :cron do
  puts "Cron. Rebuilding galleries. #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}"
  
  require './app/app'
  
  include DropboxrHelpers
  
  all_fine, extra_info = build_galleries
  
  body = extra_info.to_s
  subject = all_fine ? "Cron Executed!" : "Cron Failed!"

  Pony.mail :to             => 'pieter@noort.be',
            :from           => 'pieter@noort.be',
            :subject        => subject, 
            :body           => body, 
            :via            => :smtp, 
            :via_options    => {:address                => 'smtp.gmail.com',
                                :port                   => '587',
                                :enable_starttls_auto   => true,
                                :user_name              => ENV['GMAIL_USER'],
                                :password               => ENV['GMAIL_PASSWORD'],
                                :authentication         => :plain,
                                :domain                 => "noort.be"
                               }
end