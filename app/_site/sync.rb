require 'rubygems'
require 'fileutils'


JEKYLL_FILES = ['_site', '_includes', '_posts', '_layouts', '_plugins', 'images', 'assets']



# Creates a page name from filename
#
# file - the filename
#
# Example
#   images/about.txt #=> about
#
# Returns a string
def file_name_to_page_name(file)
  file.split('/')[1].split('.')[0]
end


# Getting Pages from site
#
# Returns an array of existing pages
def get_pages_from_site
  ret = []
  pattern = File.join('**')
  Dir.glob(pattern).each do |f|
    ret << "#{f}" if File.directory?(f) && !JEKYLL_FILES.include?(f)
  end
  ret
end


# Getting Pages from Dropbox
#
# Each .txt file in the root directory will become a page
#
# Returns an array of pages
def get_pages_from_dropbox
  ret = []
  pattern = File.join('images', '*.txt')
  Dir.glob(pattern).each do |f|
    ret << "#{file_name_to_page_name f}"
  end
  ret
end


# Creating a single Page
#
# page_name - the name of page to be created
def create_page(page_name)
  Dir.mkdir page_name unless File.exists? page_name
  f = File.new("#{page_name}/index.html", 'w+')
  str = "---\n"
  str += "layout: page\n"
  str += "title: #{page_name}\n"
  str += "---\n"
  f.write str
  
  File.open("images/#{page_name}.txt").readlines.each do |line|
    f.write line
    f.write '<br/>'
  end
  f.close
end

# Delete a single Page
#
# page_name - the name of the page to be deleted
def delete_page(page_name)
  puts "Deleting page #{page_name}"
  FileUtils.rm_rf "#{page_name}"
end


# Pages
#
# All pages will be completely regenerated
# Pages removed from Dropbox will be removed 
def pages
  current = get_pages_from_site
  dropbox = get_pages_from_dropbox
  puts "Current pages: #{current.join(', ')}"
  puts "New pages: #{dropbox.join(', ')}"
  
  to_delete = current - dropbox
  to_delete.map {|p| delete_page p}
  
  dropbox.map {|p| create_page p}
end


pages
