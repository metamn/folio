module Utils
  # Creates a page name from filename
  #
  # file - the filename
  #
  # Example
  #   images/about.txt #=> about
  #
  # Returns a string
  def file_name_to_page_name(file)
    file.split('/')[1].split('.')[0]
  end
end
