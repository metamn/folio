require 'yaml'

require './page'
require './post'

# Generate artist portfolio from Dropbox using Jekyll
#
# Usage: folio url
#   url - the destination url where the portfolio will be generated
#
# Example
#   folio inu.ro #=> /inu.ro will contain the Jekyll site generated
#
class Folio
  
  attr_reader :dir, :config, :dropbox
  
  # Load the destination directory from passed arguments
  # args - the command line arguments
  #
  # @dir - the destination directory
  def initialize(args)
    raise ArgumentError, usage if args.empty? 
    @dir = args[0]
    puts "Output directory: #{@dir}"
    
    load_config 'config.yml'
    
    @page = Page.new("#{@dir}") 
  end
  
  # Load configuration from config.yml
  def load_config(file)
    raise SystemExit, no_config_file unless File.exists? file
    
    @config = YAML::load_file 'config.yml'
    @dropbox = @config['dropbox_folder']
    puts "Configuration loaded."
  end
  
  # Generate the Jekyll site 
  #
  # - Create the output directory
  # - Copy skeleton to output directory
  # - Symlink Dropbox folder to /images
  # - Configure Jekyll
  # - Generate pages, menus, posts
  def generate
    mkdir(@dir) unless Dir.exists? @dir
    skeleton
    symlink
    config
    pages
    menu
    posts
  end
  
  # Create the output directory
  def mkdir(dir)
    puts "Creating output directory #{dir}"
    Dir.mkdir dir
  end
  
  # Copy skeleteon to output directory
  def skeleton
    puts "Copying skeleton ..."
    system("cp -Rf skeleton/* #{@dir}/")
  end
  
  # Symlink portfolio items from Dropbox into /images in output directory
  def symlink
    puts "Linking images from Dropbox ..."
    raise ArgumentError, no_dropbox_folder unless Dir.exists?("#{@dropbox}/#{@dir}")
    system("ln -s #{@dropbox}/#{@dir}/ #{@dir}/images") unless Dir.exists?("#{@dir}/images")
  end
  
  # Configure Jekyll via _config.yml
  # 
  # The content of 'config.txt' from the Dropbox folder will be copied to '_config.yml' in Jekyll
  def config
    puts "Setting up Jekyll ..."
    raise ArgumentError, no_jekyll_config_file unless File.exists? "#{@dropbox}/#{@dir}/config.site"
    
    system("cp #{@dropbox}/#{@dir}/config.site #{@dir}/_config.yml")
  end
  
  # Generate Jekyll pages
  #
  # See more at page.rb
  def pages
    @page.sync
  end  
  
  # Generate Jekyll menus
  #
  # See more at content.rb
  def menu
    Content.new("#{@dir}").menu @page.dropbox
  end
  
  # Generate Jekyll posts
  #
  # See more at post.rb
  def posts
    Post.new("#{@dir}").sync
  end
  
  
  
  #
  # Error messages
  #
  # Display a message how to use Folio
  def usage
    puts "Usage: folio url"
    puts "url - the destination url where the portfolio will be generated"
    puts "Example: folio inu.ro #=> /inu.ro will contain the Jekyll site generated"    
    puts
    exit
  end
  
  # Display a message if Dropbox source folder doesn't exists
  def no_dropbox_folder
    puts "Cant find portfolio source files in Dropbox (#{@dropbox}/#{@dir}/)"
    puts
    exit
  end
  
  # Display a message if config file not found
  def no_config_file
    puts "can't find configuration file 'config.yml'"
    puts
    exit
  end
  
  # Display a message if config file not found
  def no_jekyll_config_file
    puts "can't find configuration file for Jekyll 'config.txt'"
    puts
    exit
  end
end


f = Folio.new ARGV
f.generate

