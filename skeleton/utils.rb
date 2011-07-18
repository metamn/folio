class String
   def titleize
      non_capitalized = %w{of etc and by the for on is at to but nor or a via}
      gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }.gsub /-/, ' '
   end
end


module Utils
  # Folders used by Jekyll
  JEKYLL_FOLDERS = ['_site', '_includes', '_posts', '_layouts', '_plugins', 'images', 'assets']
  
  # Checking if a folder belongs to Jekyll 
  # 
  # folder - the folder name
  #
  # Returns boolean
  def jekyll_folders?(folder)
    JEKYLL_FOLDERS.include? folder
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
  
  # Remove 'images/' prefix from filename
  #
  # file - the file name
  #
  # Returns a string
  def remove_prefix(file)
    file.split('images/')[1]
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
end