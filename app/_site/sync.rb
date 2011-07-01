require 'rubygems'
require './page.rb'

pages = Page.new
pages.sync

puts "menu: #{pages.dropbox}"
Content.new.menu pages.dropbox
