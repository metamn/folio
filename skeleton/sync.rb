require 'rubygems'
require 'fileutils'
require './utils.rb'
require './content.rb'
require './page.rb'
require './post.rb'


pages = Page.new
pages.sync
puts

puts "menu: #{pages.dropbox}"
Content.new.menu pages.dropbox
puts

posts = Post.new
posts.sync
