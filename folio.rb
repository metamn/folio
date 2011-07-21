require './page'
require './post'

# Generate artist portfolio from Dropbox using Jekyll
#
# Usage: folio url
#   url - the destination url where the portfolio will be generated
#
# Examples
#
#   folio inu.ro 
#   #=> /inu.ro will contain the Jekyll site generated
#
# Returns a Jekyll site
class Folio

  include Utils
  
  attr_reader :dir, :config, :dropbox
  
  # Initialize Folio
  #
  # args - the command line arguments
  #
  # Sets the following variables:
  # dir - the output directory
  # config - configuration loaded from 'config.yml'
  #
  # Page is initialized here and used later in generating pages and menu
  #
  # Returns nothing
  def initialize(args)
    raise ArgumentError, usage if args.empty? 
    @dir = args[0]
    puts "Output directory: #{@dir}"
    
    load_config
    
    @page = Page.new("#{@dir}", @config['page_extension']) 
  end
  
  # Loading config file and setting up variables
  # Configuration is loaded once and sent later to other classes as a parameter
  #
  # Returns nothing
  def load_config
    @config = load_yaml 'config.yml'
    @dropbox = @config['dropbox_folder']
    @config_file = @config['config_file']
    puts "Configuration loaded."
  end
  
  # Generate the Jekyll site 
  #
  # - Create the output directory
  # - Copy skeleton to output directory
  # - Symlink Dropbox folder to /images
  # - Configure Jekyll
  # - Generate pages, menus, posts
  #
  # Returns nothing
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
  #
  # dir - the output directory
  #
  # Returns nothing
  def mkdir(dir)
    puts "Creating output directory #{dir}"
    Dir.mkdir dir
  end
  
  # Copy skeleton to output directory
  #
  # Returns nothing
  def skeleton
    puts "Copying skeleton ..."
    system("cp -Rf skeleton/* #{@dir}/")
  end
  
  # Symlink portfolio items from Dropbox into /images in output directory
  #
  # Returns nothing
  def symlink
    puts "Linking images from Dropbox ..."
    raise ArgumentError, no_dropbox_folder unless Dir.exists?("#{@dropbox}/#{@dir}")
    system("ln -s #{@dropbox}/#{@dir}/ #{@dir}/images") unless Dir.exists?("#{@dir}/images")
  end
  
  # Configure Jekyll via _config.yml
  # 
  # The content of the config file from Dropbox will be copied to '_config.yml' in Jekyll
  #
  # Returns nothing
  def config
    puts "Setting up Jekyll ..."
    raise ArgumentError, no_jekyll_config_file unless File.exists? "#{@dropbox}/#{@dir}/#{@config_file}"
    
    system("cp #{@dropbox}/#{@dir}/#{@config_file} #{@dir}/_config.yml")
  end
  
  # Generate Jekyll pages
  #
  # See more at page.rb
  #
  # Returns nothing
  def pages
    @page.sync
  end  
  
  # Generate Jekyll menus
  #
  # See more at content.rb
  #
  # Returns nothing
  def menu
    puts "Creating menu ..."
    Content.new("#{@dir}", "#{@extension}").menu @page.dropbox
  end
  
  # Generate Jekyll posts
  #
  # See more at post.rb
  #
  # Returns nothing
  def posts
    Post.new("#{@dir}").sync
  end
  
  
  
  # Display a message how to use Folio
  #
  # Returns nothing
  def usage
    puts "Usage: folio url"
    puts "url - the destination url where the portfolio will be generated"
    puts "Example: folio inu.ro #=> /inu.ro will contain the Jekyll site generated"    
    puts
    exit
  end
  
  # Display a message if Dropbox source folder doesn't exists
  #
  # Returns nothing
  def no_dropbox_folder
    puts "Cant find portfolio source files in Dropbox (#{@dropbox}/#{@dir}/)"
    puts
    exit
  end
    
  # Display a message if config file not found
  #
  # Returns nothing
  def no_jekyll_config_file
    puts "can't find configuration file for Jekyll '#{@config_file}'"
    puts
    exit
  end
end


f = Folio.new ARGV
f.generate

