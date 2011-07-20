require 'yaml'

# Generating Jekyll content
#
class Content
  include Utils
  
  def initialize(dir)
    @dir = dir
  end

  # Generate post for Jekyll
  #
  # file - the file name with all folders
  #
  # Metadata is added from directory and file descriptors, if any
  # If there is no metadata the post will get default data
  def post(file)
    metadata = self.meta(file)
    
    f = File.new "#{@dir}/_posts/#{metadata['date'].to_s}-#{file_name_to_page_name file}.html", 'w+'
    f.puts YAML.dump metadata
    f.close
  end

  # Generate menu items from pages
  # Menu items are put in a Jekyll partial
  # An additional item "Home" is added
  #  
  # items - an array of page names
  #
  # Returns '_includes/menu.html'
  def menu(items)
    f = File.new("#{@dir}/_includes/menu.html", 'w+')
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
    page_name = p.split('/')[1]
    
    f = File.new("#{p}/index.html", 'w+')
    f.puts "---"
    f.puts "layout: page"
    f.puts "title: #{page_name.titleize}"
    f.puts "---"
    
    self.copy f, "#{@dir}/images/#{page_name}.txt"
    f.close
  end
  
  protected
  
    # Get the post meta data
    #
    # file - the file name with all folders
    #
    # Inheritance/merging follows hierarchy: folder/subfolder/file-descriptor
    #
    # Steps:
    # 1. the default meta data is created
    # 2. the descriptor files are merged into default overwriting them
    #
    # Returns a YAML hash
    def meta(file)
      ret = meta_default folder_categories file 
      
      yamls = meta_files(file) + meta_file(file)
      yamls.flatten.each do |y| 
        data = YAML.load_file("#{@dir}/images/#{y}")
        ret = meta_merge ret, data unless data == false
      end
      
      ret
    end
    
    
    # Merging multiple metadatas
    #
    # old_meta - the current metadata
    # new_meta - the new metadata to add
    #
    # Categories are added
    # Dates are overwritten
    # 
    # Returns YAML
    def meta_merge(old_meta, new_meta)
      old_meta.merge(new_meta) { |key, oldval, newval| 
        case key
        when "categories"
          oldval + newval 
        else
          newval
        end  
      }
    end
    
    
    # Creating default metadata for posts
    #
    # categories - an array of categories derived from folder names
    #
    # Default post time will be the current time
    #
    # Returns a YAML
    def meta_default(categories)
      str = "date: #{Time.now.to_s.split(' ')[0]}\n"
      str += "categories: [#{categories.join(', ')}]"
      YAML.load str
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
      ret << ["#{file.split('.')[0]}.txt"] if File.exists? "#{@dir}/images/#{file.split('.')[0]}.txt"
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
        ret << f if File.exists? "#{@dir}/images/#{f}"
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
