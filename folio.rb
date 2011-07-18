# Generate artist portfolio from Dropbox using Jekyll
#
# Usage: folio url
#   url - the destination url where the portfolio will be generated
#
# Example
#   folio inu.ro #=> /inu.ro will contain the Jekyll site generated
#
class Folio
  def initialize(args)
    usage if args.empty? 
    @dir = args[0]
  end
  
  # Displays a message how to use Folio
  def usage
    puts "Usage: folio url"
    puts "url - the destination url where the portfolio will be generated"
    puts "Example: folio inu.ro #=> /inu.ro will contain the Jekyll site generated"
    puts
  end
end


