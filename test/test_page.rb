require "test/unit"
require "shoulda"
require "redgreen"

require 'jekyll'
#require 'jekyll/site'

require "./page"

class TestPage < Test::Unit::TestCase

  context "Running Page without output dir as argument" do  
    should "raise an error" do
      assert_raise(ArgumentError) { Page.new }
    end    
  end
  
  context "Running Page with proper output dir as argument" do
    
    def setup
      @page = Page.new 'demo'
    end
    
    should "initialize the @dir variable" do
      assert_not_nil @page.dir
    end
    
    should_eventually "collect existing pages from Jekyll" do
      config = Jekyll.configuration Hash["source" => 'demo']
      site = Jekyll::Site.new(config).tap { |site| site.read } 
      puts "pages:" + site.paginator.total_pages
    end
  end
end

