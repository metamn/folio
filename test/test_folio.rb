require "test/unit"
require "shoulda"
require "redgreen"

require "./folio"
 
class TestFolio < Test::Unit::TestCase
 
  context "Running folio without arguments" do
    should "raise an exception" do
      assert_raise(ArgumentError) { Folio.new }
    end
  end
  
   
  context "Running folio with arguments" do
  
    def setup
      @f = Folio.new ['demo']
    end
        
    should "not raise an exception" do
      assert_nothing_raised(ArgumentError) { @f }
    end 
    
    should "load configuration file" do
      assert_not_nil @f.config
    end
    
    should "raise exception when configuration file is missing" do
      assert_raise(SystemExit) { @f.load_config 'alika' }
    end
    
    should "create the output directory unless already exists" do
      @f.mkdir 'demodir'
      assert Dir.exists?('demodir')
      Dir.rmdir('demodir')      
    end
    
    should "copy skeleton to output directory" do
      @f.mkdir @f.dir unless Dir.exists? @f.dir
      @f.skeleton
      assert File.exists? "#{@f.dir}/_config.yml"
    end
    
    should "create a symlink in output direcory for images" do
      @f.symlink
      assert Dir.exists? "#{@f.dir}/images"
    end
    
    should "create the symlink for images only once" do
      @f.symlink
      assert !(Dir.exists? "#{@f.dir}/images/#{@f.dir}")
    end
    
    should "configure the new static site via _config.yml" do
      @f.config
      source = YAML::load_file "#{@f.dir}/images/config.site"
      dest = YAML::load_file "#{@f.dir}/_config.yml"
      assert_equal source, dest
    end
    
    should "generate pages" do
      @f.pages
      assert Dir.exists? "#{@f.dir}/about"
    end
    
    should "generate menu" do
      before = File.open("#{@f.dir}/_includes/menu.html", 'r').size
      @f.menu
      assert File.open("#{@f.dir}/_includes/menu.html", 'r').size > before
    end
    
    should "generate posts" do
      before = Dir.entries("#{@f.dir}/_posts").size
      @f.posts
      assert Dir.entries("#{@f.dir}/_posts").size > before
    end
  end
end

