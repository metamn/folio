require 'rubygems'


# Building categories 
#
# It takes all folders from /images and creates categories from folder names
#
# Returns an array of category names
def categories
  Dir.foreach('images') do |d|
    puts "#{d}"
  end
end
