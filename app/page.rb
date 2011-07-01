require 'fileutils'
require './utils.rb'
require './content.rb'


# Creating Jekyll Pages from Dropbox data
#
class Page
  
  include Utils
  
  # Folders used by Jekyll
  JEKYLL_FOLDERS = ['_site', '_includes', '_posts', '_layouts', '_plugins', 'images', 'assets']
  
  
  # Syncing Dropbox data with Jekyll
  #
  # Pages removed from Dropbox will be removed from Jekyll
  #
  # All Pages from Dropbox will be regenerated in Jekyll
  def sync
    puts "Current pages: #{jekyll.join(', ')}"
    puts "New pages: #{dropbox.join(', ')}"
    
    to_delete = jekyll - dropbox
    to_delete.map {|p| delete p}
    
    dropbox.map {|p| create p}
  end
  
  # Getting existing Pages from Jekyll
  #
  # Returns an array of page names
  def jekyll
    pattern = File.join('**')
    ret = Dir.glob(pattern).map! {|f| (File.directory?(f) && !JEKYLL_FOLDERS.include?(f)) ? "#{f}" : "" }.uniq
    ret.delete("")
    ret
  end
  
  # Getting Pages from Dropbox
  #
  # Returns an array of page names
  def dropbox
    pattern = File.join('images', '*.txt')
    Dir.glob(pattern).map {|f| "#{file_name_to_page_name f}" }
  end
  
  # Delete Page from Jekyll
  #
  # p - the name of the page
  def delete(p)
    puts "Deleting page #{p}"
    FileUtils.rm_rf "#{p}"
  end
  
  # Create a Jekyll Page
  #
  # p - the name of the page
  def create(p)
    Dir.mkdir p unless File.exists? p
    Content.new.page p
  end
  
end
