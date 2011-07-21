pattern = File.join("./", "*.rb")
Dir.glob(pattern).each do |f|
  file = f.split('./')[1].split('.')[0]
  puts "Documenting #{file} ..."
  system "tomdoc -f html #{f} > doc/#{file}.html"
end

puts "Generating index.html"

nav = ""
pattern = File.join("doc/", "*.html")
Dir.glob(pattern).each do |f|
  nav += "<a href='#{f}'>#{f}</a><br/>"  
end
File.open('readme.html', 'w') {|f| f.write nav}

puts "Documentation done. Check readme.html"
