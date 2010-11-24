require 'pony'

task :default => :build

desc 'Maintain galleries'
task :cron do
  puts "Building galleries. #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}"
  
  Pony.mail :to             => 'pieter@wellconsidered.be',
            :from           => 'info@dropboxr',
            :subject        => 'Cron executed!', 
            :via            => :smtp, 
            :via_options    => {:address                => 'smtp.gmail.com',
                                :port                   => '587',
                                :enable_starttls_auto   => true,
                                :user_name              => ENV['GMAIL_USER'],
                                :password               => ENV['GMAIL_PASSWORD'],
                                :authentication         => :plain,
                                :domain                 => "wellconsidered.be"
                               } # , 
            # :attachments    => {''}
end