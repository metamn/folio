require 'fileutils'
require './utils'
require './content'

# Creating Jekyll Pages from Dropbox data
#
class Page  
  include Utils  
  
  def initialize(dir)
    @dir = dir
    @content = Content.new dir
  end
  
  
  # Syncing Dropbox pages with Jekyll
  #
  # Pages removed from Dropbox will be removed from Jekyll
  #
  # All Pages from Dropbox will be regenerated in Jekyll
  def sync
    puts "Current pages: #{jekyll.join(', ')}"
    puts "New pages: #{dropbox.join(', ')}"
    
    to_delete = jekyll - dropbox
    to_delete.map {|p| delete "#{@dir}/#{p}"}
    
    dropbox.map {|p| create "#{@dir}/#{p}"}
  end
  
  # Getting existing Pages from Jekyll
  #
  # Returns an array of page names
  def jekyll
    pattern = File.join("#{@dir}", '**')
    ret = Dir.glob(pattern).map! {|f| (File.directory?(f) && !jekyll_folders?(f)) ? "#{f}" : "" }.compact.uniq
    ret.delete("")
    ret
  end
  
  # Getting Pages from Dropbox
  #
  # Returns an array of page names
  def dropbox
    pattern = File.join("#{@dir}/images", '*.txt')
    Dir.glob(pattern).map {|f| "#{file_name_to_page_name f}" }.compact
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
    puts "Creating page #{p}"
    Dir.mkdir p unless File.exists? p
    @content.page p
  end
  
end
