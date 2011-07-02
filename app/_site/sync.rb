require 'rubygems'
require 'fileutils'
require './utils.rb'
require './content.rb'
require './page.rb'

pages = Page.new
pages.sync

puts "menu: #{pages.dropbox}"
Content.new.menu pages.dropbox


posts = Post.new
posts.sync
