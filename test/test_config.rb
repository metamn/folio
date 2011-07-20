require "test/unit"
require "shoulda"
require "redgreen"

require 'yaml'

class TestFolio < Test::Unit::TestCase
  def setup
    @y = YAML::load_file 'config.yml'
  end
  
  context "The config file" do
  
    should "have an entry for the Dropbox folder location" do
      assert @y['dropbox_folder']
    end
    
  end
  
end
