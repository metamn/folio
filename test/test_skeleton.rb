require "test/unit"
require "shoulda"
require "redgreen"

require 'yaml'

class TestSkeleton < Test::Unit::TestCase
  def setup
    @y = YAML::load_file 'skeleton/_config.yml'
  end
  
  context "The skeleton config file" do
  
    should "have an entry for site.name" do
      assert @y['name']
    end
    
    should "have an entry for site.strapline" do
      assert @y['strapline']
    end
    
    should "have an entry for site.year" do
      assert @y['year']
    end
  end
  
end
