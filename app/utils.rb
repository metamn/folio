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
  #
  # Returns a string
  def file_name_to_page_name(file)
    file.gsub! /\s/, '-'
    file.split('/')[1].split('.')[0]
  end
end
