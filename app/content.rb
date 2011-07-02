require 'yaml'

# Generating Jekyll content
#
class Content
  include Utils

  # Generate post for Jekyll
  #
  # file - the file name with all folders
  #
  # Metadata is added from directory and file descriptors, if any
  # If there is no metadata the post date will be the current date
  def post(file)
    meta = self.meta(file) 
  end

  # Generate menu items from pages
  # Menu items are put in a Jekyll partial
  # An additional item "Home" is added
  #  
  # items - an array of page names
  #
  # Returns '_includes/menu.html'
  def menu(items)
    f = File.new("_includes/menu.html", 'w+')
    f.puts "<ul class='inline-list'>"
    f.puts "  <li><a href='/' title='Home'>Home</a></li>"
    items.map {|i| f.puts "  <li><a href='/#{i}' title='#{i.titleize}'>#{i.titleize}</a></li>"}
    f.puts "</ul>"
    f.close
  end

  # Generate content for a Jekyll page from file
  #
  # p - page name
  #
  def page(p)
    f = File.new("#{p}/index.html", 'w+')
    f.puts "---"
    f.puts "layout: page"
    f.puts "title: #{p.titleize}"
    f.puts "---"
    
    self.copy f, "images/#{p}.txt"
    f.close
  end
  
  protected
  
    # Get the post meta data
    #
    # file - the file name with all folders
    #
    # Inheritance follows hierarchy: folder/subfolder/file-descriptor
    #
    # Returns a YAML file
    def meta(file)
      puts file            
      puts meta_files file
      puts meta_file file
      puts
    end
    
    # Getting the meta descriptor file for a single file
    #
    # file - the name of the file with folders
    #
    # Returns the descriptor file as a single element array if exists or empty
    #
    # Example
    #   dir1/dir11/index.png #=> ['dir1/dir11/index.txt']
    def meta_file(file)
      ret = []
      ret << ["#{file.split('.')[0]}.txt"] if File.exists? "images/#{file.split('.')[0]}.txt"
      ret
    end
    
    # Getting the meta descriptor files for directories
    #
    # file - the file name with all folders
    #
    # Returns an array of descriptor files or empty
    #
    # Example
    #   directory structure:
    #     dir1/dir1.txt
    #     dir1/dir11/index.png
    #   file - dir1/dir11/index.png  #=> ['dir1/dir1.txt']
    #
    # Example 2
    #   directory structure:
    #     dir1/dir1.txt
    #     dir1/dir11/index.png
    #     dir1/dir11/dir11.txt
    #   file - dir1/dir11/index.png  #=> ['dir1/dir1.txt', 'dir1/dir11/dir11.txt']
    def meta_files(file)
      ret = []
      folders = folder_categories file
      folders.each_with_index do |folder, index|
        f = "#{folders.take(index+1).join('/')}/#{folder}.txt"
        ret << f if File.exists? "images/#{f}"
      end
      ret
    end
    
    
    # Add content from a file to another file
    #
    # source - the source file name
    # dest - the already opened destination file object
    def copy(dest, source)
      File.open(source).readlines.each do |line|
        dest.puts line      
      end
    end
end
