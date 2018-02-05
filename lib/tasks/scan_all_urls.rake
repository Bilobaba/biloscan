require 'pry'

namespace :scan_all_urls do
  desc "Scan all urls"
  task :my_task => :environment do
    puts "******************************* Hello rake begin ******************************"
    UrlsController.new.scan_all_task
    puts "******************************* Hello rake end ******************************"
  end
end
