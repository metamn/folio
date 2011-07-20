# Creating posts from Dropbox data
#
class Post
  include Utils
  
  IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'png', 'tiff', 'gif']

  # Initialize Post class
  #
  # dir - the output directory
  #
  # Returns @files an array of posts to be created
  def initialize(dir)
    @dir = dir
    @files = files 
  end
  
  # Getting directories and files for posts
  #
  # Returns an array of dirs and filenames
  #
  # Example
  #
  #   dir1/file.txt
  #   dir1/noun_project_220_2-headphone.svg
  #   dir1/noun_project_293_6-home.svg
  #   dir1/noun_project_632_1-listen.svg
  #   dir1/noun_project_61-bus.svg
  #   dir1/dir11/file.txt
  #   dir1/dir11/flower.png
  #   dir1/dir11/light.png
  #
  def files    
    @files = Dir.glob File.join "#{@dir}/images", '**', '**' # get all files recursively from 'images'
    @files -= Dir.glob File.join "#{@dir}/images", '*.txt' # remove pages
    @files -= Dir.glob File.join "#{@dir}/images", '*.site' # remove config.site    
    @files.reject! {|i| File.directory?(i)} # remove directories, keep just the files (ie 'dir1', 'dir1/dir11')
    @files.reject! {|i| i.include?('.txt')} # remove descriptors
    @files.map! {|i| remove_prefix i, "#{@dir}"}  # remove 'inu.ro/images/' prefix
    
    @files
  end
  
  # Syncing Dropbox posts with Jekyll
  #
  # All existing posts will be removed otherwise merging all metadata is very complicated
  def sync
    puts "Removing all existing posts"
    delete
    
    puts "New posts: #{@files.size}"
    @files.map {|p| create p } 
  end
  
  
  # Delete all existing posts
  #
  def delete
    FileUtils.rm_rf "#{@dir}/_posts/*"
  end
  
  # Create a post
  #
  #
  def create(p)
    #puts "#{file_name_to_page_name p} -> #{folder_categories p}"
    Content.new("#{@dir}").post p
  end
  
  
end
