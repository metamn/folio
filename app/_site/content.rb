# Generating Jekyll content
#
class Content

  # Generate menu items from pages
  # Menu items are put in a Jekyll partial
  #  
  # items - an array of page names
  #
  # Returns '_includes/menu.html'
  def menu(items)
    f = File.new("_includes/menu.html", 'w+')
    f.puts "<ul class='inline-list'>"
    f.puts "  <li><a href='/'>Home</a></li>"
    items.map {|i| f.puts " <li><a href='/#{i}'>#{i}</a></li>"}
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
    f.puts "title: #{p}"
    f.puts "---"
    
    self.copy f, "images/#{p}.txt"
    f.close
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
