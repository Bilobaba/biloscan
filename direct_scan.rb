require 'watir'
require 'pry'
require 'diffy'
require 'phantomjs'


      url = 'http://localhost:3000/pages/test2'

binding.pry
      browser = Watir::Browser.new :chrome, headless: true
binding.pry
      browser.goto(url)
binding.pry
      puts browser.text
      browser.close
