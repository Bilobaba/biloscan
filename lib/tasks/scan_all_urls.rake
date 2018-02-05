require 'pry'

namespace :scan_all_urls do
  desc "Scan all urls"
  task :my_task do
    puts "Hello rake begin"
    Url.all.each do |u|
      puts u.path
    end
    UrlsController.new.scan_all_task
    puts "Hello rake end"
  end
end
