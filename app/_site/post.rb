# Creating posts from Dropbox data
#
class Post
  include Utils
  
  IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'png', 'tiff', 'gif']
  
  # Getting directories and files for posts
  #
  # dir - the folder where data for posts sits
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
  def initialize(dir = 'images')
    @dropbox = Dir.glob File.join "#{dir}", '**', '**' # get all files
    @dropbox -= Dir.glob File.join "#{dir}", '*.txt' # remove pages
    @dropbox.reject! {|i| !i.include?('.')} # remove directory entries, just keep files
    @dropbox.map! {|i| remove_prefix i}  # remove prefix
  end
  
  # Syncing Dropbox posts with Jekyll
  #
  # All existing posts will be removed otherwise merging all metadata is very complicated
  def sync
    puts "Removing all existing posts"
    delete
    
    puts "New posts: #{@dropbox.size}"
    @dropbox.map {|p| create p unless p.include? '.txt' } # descriptors will be skipped
  end
  
  
  # Delete all existing posts
  #
  def delete
    FileUtils.rm_rf '_posts/*'
  end
  
  # Create a post
  #
  #
  def create(p)
    #puts "#{file_name_to_page_name p} -> #{folder_categories p}"
    Content.new.post p
  end
  
  
end
