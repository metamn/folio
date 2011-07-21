class String
   def titleize
      non_capitalized = %w{of etc and by the for on is at to but nor or a via}
      gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }.gsub /-/, ' '
   end
end


module Utils
  # Folders used by Jekyll
  JEKYLL_FOLDERS = ['_site', '_includes', '_posts', '_layouts', '_plugins', 'images', 'assets']
 
  # Load config file
  #
  # file  - the YAML file to load
  #
  # Returns the content of the YAML file
  def load_yaml(file)
    raise SystemExit, no_config_file(file) unless File.exists? file    
    @config = YAML::load_file file    
  end
  
  # Checking if a folder belongs to Jekyll 
  # 
  # folder - the folder name
  #
  # Returns boolean
  def jekyll_folders?(folder)
    JEKYLL_FOLDERS.include? remove_output_folder folder
  end
  
  # Remove output folder from file name
  #
  # f - file name with output folder
  #
  # Example:
  #   "inu.ro/about" => "about"
  #
  # Returns string
  def remove_output_folder(f)
    f.split('/')[1]
  end   
  
  # Creates a page name from filename
  #
  # file - the filename
  #
  # Example
  #   images/about.txt #=> about
  #   about.txt #=> about
  #
  # Returns a string
  def file_name_to_page_name(file)
    file.gsub! /\s/, '-'
    file.gsub! /_/, '-'
    file.reverse.split('.')[1].split('/')[0].reverse
  end
  
  # Remove 'inu.ro/images/' prefix from filename
  #
  # file - the file name
  # output_dir - the output directory
  #
  # Returns a string
  def remove_prefix(file, output_dir)
    file.split("#{output_dir}/images/")[1]
  end
  
  # Creates categories from folders
  #
  # file - the file name
  #
  # Example
  #   /dir1/dir12/avil.jpg #=> [dir1, dir2] 
  #
  # Returns and array of strings
  def folder_categories(file)
    all = file.split('.')[0].split('/') 
    all.delete all.last
    all
  end
  
  
  # Error messages
  #
  # Display a message if config file not found
  #
  # file - the file not found
  def no_config_file(file)
    puts "can't find configuration file '#{file}'"
    puts
    exit
  end
  
end
