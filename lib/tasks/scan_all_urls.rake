require 'pry'

namespace :scan_all_urls do
  desc "Scan all urls"
  task :my_task do
    puts "Hello rake"
    UrlsController.new.scan_all_task
  end
end
